param([switch]$Fast)
$ErrorActionPreference = 'Stop'
function Stage($n,$b){ Write-Host "== $n =="; & $b; if($LASTEXITCODE -ne 0){ Write-Error "$n failed"; exit 1 } }
Stage 'build' { npm run build --if-present }
Stage 'links' { Write-Error "links stage not wired: run a link checker here (e.g. lychee)"; exit 1 }
if(-not $Fast){
  Stage 'lighthouse' { Write-Error "lighthouse stage not wired: run Lighthouse CI here"; exit 1 }
  Stage 'a11y' { Write-Error "a11y stage not wired: run an accessibility check here (e.g. pa11y)"; exit 1 }
}
Write-Host 'verify OK'
