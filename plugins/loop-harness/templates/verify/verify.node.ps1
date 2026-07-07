param([switch]$Fast)
$ErrorActionPreference = 'Stop'
function Stage($n,$b){ Write-Host "== $n =="; & $b; if($LASTEXITCODE -ne 0){ Write-Error "$n failed"; exit 1 } }
Stage 'build' { npm run build --if-present }
Stage 'test'  { npm test --silent }
Stage 'lint'  { npm run lint --if-present }
# Stage 'contract' { npx spectral lint contract/openapi.yaml }
Stage 'secrets' {
  if (Get-Command gitleaks -ErrorAction SilentlyContinue) {
    gitleaks detect --no-git --redact --exit-code 1
  } else {
    $hits = Get-ChildItem -Recurse -Include *.ts,*.js,*.json -ErrorAction SilentlyContinue |
      Where-Object { $_.FullName -notmatch '[\\/](\.git|node_modules|dist|build)[\\/]' -and $_.FullName -notmatch '(?i)(test|fixture)' } |
      Select-String -Pattern 'AKIA|BEGIN (RSA |EC |DSA )?PRIVATE KEY|password\s*=\s*[''"][^''"\s]{3,}' -List
    if ($hits) { Write-Error 'possible secret'; exit 1 } else { 'clean (regex fallback — install gitleaks for a real scan)' }
  }
}
if(-not $Fast){ Write-Host '== full-only stages (e2e, evals) here ==' }
Write-Host 'verify OK'
