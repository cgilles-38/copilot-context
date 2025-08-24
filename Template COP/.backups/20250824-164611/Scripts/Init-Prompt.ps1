param(
  [Parameter(Mandatory=$true)][string]$Title,
  [string]$DateTimeOverride,
  [switch]$DryRun,
  [switch]$Open
)

if([string]::IsNullOrWhiteSpace($PSScriptRoot)){ $root = (Get-Location).Path } else { $root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path }
$promptFile = Join-Path $root 'Prompt.md'
if(-not (Test-Path $promptFile)){ Write-Host 'Prompt.md introuvable' -ForegroundColor Red; exit 1 }

$content = Get-Content -Raw -Path $promptFile
$idRegex = 'PROMPT-\d{8}-\d{4}-\d{2}'
$existing = [regex]::Matches($content,$idRegex) | ForEach-Object { $_.Value }

if($DateTimeOverride){
  try { $dt = [DateTime]::Parse($DateTimeOverride) } catch { Write-Host "DateTimeOverride invalide" -ForegroundColor Red; exit 1 }
} else { $dt = Get-Date }
$prefix = "PROMPT-" + $dt.ToString('yyyyMMdd-HHmm')
$same = $existing | Where-Object { $_ -like "$prefix-*" }
if($same){ $max = ($same | ForEach-Object { ($_ -split '-')[-1] } | ForEach-Object {[int]$_} | Measure-Object -Maximum).Maximum; $seq = '{0:00}' -f ($max+1) } else { $seq = '01' }
$id = "$prefix-$seq"

$display = $dt.ToString('dd/MM/yyyy HH:mm')
$row = "| $id | $display | $Title |"

$lines = $content -split "`n"
$headerIdx = ($lines | Select-String -Pattern '^\| ID \|' | Select-Object -First 1).LineNumber
if(-not $headerIdx){ Write-Host 'Table index non trouvée' -ForegroundColor Red; exit 1 }
$headerIdx = $headerIdx -1
$tableRows = @()
for($i=$headerIdx+1;$i -lt $lines.Count;$i++){ $l=$lines[$i]; if($l -match '^\| PROMPT-'){ $tableRows+=$l; continue } if($l -eq '' -or $l -notmatch '^\|'){ break } }

$all = $tableRows + $row | Sort-Object { ($_ -split '\|')[1].Trim() }
$before = $lines[0..$headerIdx]
$afterStart = $headerIdx + 1 + $tableRows.Count
$after = if($afterStart -lt $lines.Count){ $lines[$afterStart..($lines.Count-1)] } else { @() }
$newContent = ($before + $all + $after) -join "`n"

$section = @"
---

## $id $Title - $display

**Profil :** (à compléter)
**Contraintes :** (à compléter)
**Mission :** (à compléter)
**Référence contexte :** (à compléter)
"@

if($DryRun){
  Write-Host "[DRYRUN] ID généré: $id" -ForegroundColor Yellow
  Write-Host "[DRYRUN] Ajout ligne index + section + fichiers summary/result" -ForegroundColor Yellow
  exit 0
}

Set-Content -Path $promptFile -Value ($newContent + "`n`n" + $section) -Encoding UTF8
$sumDir = Join-Path $root 'COP/Summarize'
$resDir = Join-Path $root 'COP/Result'
$summaryPath = Join-Path $sumDir ("$id-summary.md")
$resultPath  = Join-Path $resDir ("$id-result.md")
New-Item -ItemType Directory -Force -Path $sumDir | Out-Null
New-Item -ItemType Directory -Force -Path $resDir | Out-Null
@"
# $id - $Title
Date/Heure : $display
Type : Summary

## Intent utilisateur
(placeholder)

## Réponse stratégie assistant
(placeholder)

## Échanges clés
- (placeholder)

## Décisions / Arbitrages
- (placeholder)

## Livrables / Actions réalisées
- (placeholder)

## Suivi / Prochaines étapes
- (placeholder)
"@ | Set-Content -Path $summaryPath -Encoding UTF8

@"
# $id - $Title
Date/Heure : $display
Type : Result

## Objet du prompt
(placeholder)

## Livrables tangibles
- (placeholder)

## Effets / Impact
- (placeholder)

## Points en suspens
- (placeholder)

## Liens / Références croisés
- (placeholder)
"@ | Set-Content -Path $resultPath -Encoding UTF8
Write-Host "Cree $id" -ForegroundColor Cyan
if($Open){ if(Get-Command code -ErrorAction SilentlyContinue){ & code $summaryPath $resultPath $promptFile } }
