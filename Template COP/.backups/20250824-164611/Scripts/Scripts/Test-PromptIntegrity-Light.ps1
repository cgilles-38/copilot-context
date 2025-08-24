param()
$ErrorActionPreference = 'Stop'
$idRegex = 'PROMPT-\d{8}-\d{4}-\d{2}'
$repoRoot = (Get-Location).Path
$promptFile = Join-Path $repoRoot 'Prompt.md'
if(-not (Test-Path $promptFile)){ Write-Host 'Prompt.md manquant' -ForegroundColor Red; exit 1 }
$content = Get-Content -Raw -Path $promptFile
$ids = [Regex]::Matches($content,$idRegex) | ForEach-Object { $_.Value } | Sort-Object -Unique
$fail=$false
foreach($id in $ids){
  foreach($kind in 'summary','result'){
    $path = Join-Path $repoRoot ("COP/" + ($kind -eq 'summary' ? 'Summarize' : 'Result') + "/$id-$kind.md")
    if(-not (Test-Path $path)){ Write-Host "[FAIL] $kind manquant pour $id" -ForegroundColor Red; $fail=$true }
  }
}
if($fail){ exit 1 } else { Write-Host 'OK' -ForegroundColor Green }
