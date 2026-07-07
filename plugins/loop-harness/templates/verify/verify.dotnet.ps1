param([switch]$Fast)
$ErrorActionPreference = "Stop"
function Stage($n,$b){ Write-Host "== $n ==" ; & $b ; if($LASTEXITCODE -ne 0){ Write-Error "$n failed"; exit 1 } }
Stage "build"  { dotnet build -warnaserror }
Stage "test"   { dotnet test --nologo }
# Wire the remaining stages to your project:
# Stage "contract" { spectral lint (Get-ChildItem -Recurse contract/openapi.yaml) }
# Stage "gate"     { pwsh ./build/human-gate-check.ps1 }
Stage "secrets"{
  if (Get-Command gitleaks -ErrorAction SilentlyContinue) {
    gitleaks detect --no-git --redact --exit-code 1
  } else {
    $hits = Get-ChildItem -Recurse -Include *.cs,*.json,*.yaml,*.yml -ErrorAction SilentlyContinue |
      Where-Object { $_.FullName -notmatch '[\\/](\.git|node_modules|bin|obj)[\\/]' -and $_.FullName -notmatch '(?i)(test|fixture)' } |
      Select-String -Pattern 'AKIA|BEGIN (RSA |EC |DSA )?PRIVATE KEY|password\s*=\s*[''"][^''"\s]{3,}' -List
    if ($hits) { Write-Error "possible secret"; exit 1 } else { "clean (regex fallback — install gitleaks for a real scan)" }
  }
}
if(-not $Fast){ Write-Host "== full-only stages (eval, bicep) go here ==" }
Write-Host "verify OK"
