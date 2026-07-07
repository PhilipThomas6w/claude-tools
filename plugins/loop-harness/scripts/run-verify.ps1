# Stop / SubagentStop: run the project's build/verify.ps1 -Fast. On failure, emit {decision:block,
# reason} so Claude cannot finish; on pass, when no verify script exists, or when the tree has no
# uncommitted changes, exit 0. Registered for both Stop and SubagentStop so a maker sub-agent's own
# turn is gated too, not just the main session's.
#
# Implements a real round-trip cap (default 5) per session_id, and best-effort ledger logging.
# See the claude-code-hook-facts skill for the Stop-hook schema this relies on.

$raw = [Console]::In.ReadToEnd()
$hookInput = $null
try { $hookInput = $raw | ConvertFrom-Json } catch { $hookInput = $null }
$sessionId = if ($hookInput -and $hookInput.session_id) { $hookInput.session_id } else { 'unknown' }
$transcriptPath = if ($hookInput -and $hookInput.transcript_path) { $hookInput.transcript_path } else { $null }

if (-not (Test-Path 'build/verify.ps1')) { exit 0 }

# Only gate when there is something pending to verify: skip if the tree is clean, so a pre-existing
# red repo doesn't block unrelated read-only turns (or a read-only explorer/verifier sub-agent).
$gitDirty = $true
try {
  $null = git rev-parse --is-inside-work-tree 2>$null
  if ($LASTEXITCODE -eq 0) {
    $status = git status --porcelain 2>$null
    $gitDirty = [bool]$status
  }
} catch { $gitDirty = $true }

if (-not $gitDirty) { exit 0 }

$out = & pwsh -NoProfile -File 'build/verify.ps1' -Fast 2>&1 | Out-String
$rc = $LASTEXITCODE
$outcome = if ($rc -eq 0) { 'pass' } else { 'fail' }

function Write-Ledger([string]$outcome, [string]$transcriptPath) {
  try {
    $ledgerPath = 'docs/harness/LEDGER.csv'
    if (-not (Test-Path $ledgerPath)) { return }

    $date = Get-Date -Format 'yyyy-MM-dd'

    $workItem = 'n/a'
    $stateFile = Get-ChildItem -Path 'STATE.md', '*/STATE.md', 'tools/*/STATE.md', 'agents/*/STATE.md' -File -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($stateFile) {
      $stateText = Get-Content -Raw $stateFile.FullName
      if ($stateText -match '(?ms)^## In progress\s*\r?\n(.+?)(\r?\n##|\z)') {
        $first = ($matches[1].Trim() -split "`r?`n")[0]
        if (-not [string]::IsNullOrWhiteSpace($first)) { $workItem = $first }
      }
    }

    # Best-effort: sum token usage out of the transcript JSONL. The exact schema is not guaranteed;
    # this must never break the gate, so any parse failure just leaves tokens as 'n/a'.
    $tokens = 'n/a'
    if ($transcriptPath -and (Test-Path $transcriptPath)) {
      try {
        $total = 0
        Get-Content $transcriptPath -ErrorAction Stop | ForEach-Object {
          try {
            $rec = $_ | ConvertFrom-Json -ErrorAction Stop
            $usage = $rec.message.usage
            if ($usage) {
              if ($usage.input_tokens) { $total += [int]$usage.input_tokens }
              if ($usage.output_tokens) { $total += [int]$usage.output_tokens }
            }
          } catch { }
        }
        if ($total -gt 0) { $tokens = $total }
      } catch { $tokens = 'n/a' }
    }

    $notes = 'auto-logged by run-verify.ps1'
    $row = ('{0},"{1}",n/a,{2},n/a,{3},{4}' -f $date, ($workItem -replace '"', '""'), $tokens, $outcome, $notes)
    Add-Content -Path $ledgerPath -Value $row
  } catch {
    # Ledger logging is best-effort and must never break the gate.
  }
}

Write-Ledger $outcome $transcriptPath

$counterFile = Join-Path $env:TEMP "claude-harness-stopcount-$sessionId.txt"
$maxRoundTrips = 5

if ($rc -eq 0) {
  if (Test-Path $counterFile) { Remove-Item $counterFile -ErrorAction SilentlyContinue }
  exit 0
}

$count = 0
if (Test-Path $counterFile) {
  $prev = Get-Content $counterFile -Raw -ErrorAction SilentlyContinue
  if ($prev -and ($prev.Trim() -match '^\d+$')) { $count = [int]$prev.Trim() }
}
$count++

$tail = (($out -split "`n") | Select-Object -Last 25) -join "`n"

if ($count -gt $maxRoundTrips) {
  # Cap reached: stop blocking (let the turn end) rather than looping forever. Surface the
  # instruction as additional context instead, since we are no longer blocking this turn.
  Remove-Item $counterFile -ErrorAction SilentlyContinue
  $reason = "The verify gate has now failed $($count - 1) consecutive times (cap: $maxRoundTrips). Stop retrying: write the blocker to STATE.md under 'Blocked / needs decision', including the failure tail below, then stop and wait for a human decision. Tail:`n$tail"
  (@{ hookSpecificOutput = @{ hookEventName = 'Stop'; additionalContext = $reason } }) | ConvertTo-Json -Compress -Depth 5
  exit 0
}

Set-Content -Path $counterFile -Value $count
(@{ decision = 'block'; reason = "verify gate FAILED (exit $rc), attempt $count/$maxRoundTrips. Do not finish. Fix and re-run build/verify.ps1. Tail:`n$tail" }) | ConvertTo-Json -Compress -Depth 5
exit 0
