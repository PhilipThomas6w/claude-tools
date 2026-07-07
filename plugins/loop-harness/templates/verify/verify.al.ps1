param([switch]$Fast)
$ErrorActionPreference = "Stop"
function Stage($n,$b){ Write-Host "== $n ==" ; & $b ; if($LASTEXITCODE -ne 0){ Write-Error "$n failed"; exit 1 } }
# Business Central / AL. Wire to your AL-Go / alc compiler and test toolchain — the compile step
# is the load-bearing check on this stack; there is no cheaper correctness signal before it runs.
Stage "compile" { Write-Error "compile stage not wired: run alc.exe or an AL-Go/container compile task here"; exit 1 }
Stage "test"    { Write-Error "test stage not wired: run the BC Test Toolkit here"; exit 1 }
Stage "secrets" {
  if (Get-Command gitleaks -ErrorAction SilentlyContinue) {
    gitleaks detect --no-git --redact --exit-code 1
  } else {
    $hits = Get-ChildItem -Recurse -Include *.al,*.json -ErrorAction SilentlyContinue |
      Where-Object { $_.FullName -notmatch '[\\/](\.git|node_modules|bin|obj)[\\/]' -and $_.FullName -notmatch '(?i)(test|fixture)' } |
      Select-String -Pattern 'AKIA|BEGIN (RSA |EC |DSA )?PRIVATE KEY|password\s*=\s*[''"][^''"\s]{3,}' -List
    if ($hits) { Write-Error "possible secret"; exit 1 } else { "clean (regex fallback — install gitleaks for a real scan)" }
  }
}
if(-not $Fast){ Write-Host "== full-only stages here ==" }
Write-Host "verify OK"
