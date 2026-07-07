param([switch]$Fast)
$ErrorActionPreference = 'Stop'
function Stage($n,$b){ Write-Host "== $n =="; & $b; if($LASTEXITCODE -ne 0){ Write-Error "$n failed"; exit 1 } }
Stage 'lint' { ruff check . }
Stage 'test' { pytest -q }
Stage 'secrets' {
  if (Get-Command gitleaks -ErrorAction SilentlyContinue) {
    gitleaks detect --no-git --redact --exit-code 1
  } else {
    $hits = Get-ChildItem -Recurse -Include *.py -ErrorAction SilentlyContinue |
      Where-Object { $_.FullName -notmatch '[\\/](\.git|\.venv|venv|__pycache__)[\\/]' -and $_.FullName -notmatch '(?i)(test|fixture)' } |
      Select-String -Pattern 'AKIA|BEGIN (RSA |EC |DSA )?PRIVATE KEY|password\s*=\s*[''"][^''"\s]{3,}' -List
    if ($hits) { Write-Error 'possible secret'; exit 1 } else { 'clean (regex fallback — install gitleaks for a real scan)' }
  }
}
if(-not $Fast){ Write-Host '== full-only stages (evals) here ==' }
Write-Host 'verify OK'
