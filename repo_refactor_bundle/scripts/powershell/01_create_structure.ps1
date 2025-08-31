
Param([switch]$DryRun)
$conf = "config/proposed_structure.json"
if (!(Test-Path $conf)) { Write-Error "Missing $conf"; exit 1 }
$cfg = Get-Content $conf | ConvertFrom-Json
foreach ($d in $cfg.directories) {
  if ($DryRun) { Write-Output "[DRY] mkdir $d" }
  else { New-Item -ItemType Directory -Force -Path $d | Out-Null; Write-Output "Created: $d" }
}
