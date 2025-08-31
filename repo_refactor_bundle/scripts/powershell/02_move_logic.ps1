
Param([switch]$DryRun)
$map = "config/move_map.json"
if (!(Test-Path $map)) { Write-Error "Missing $map"; exit 1 }
$cfg = Get-Content $map | ConvertFrom-Json
$props = $cfg.mapping | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
foreach ($name in $props) {
  $src = $name
  $dst = $cfg.mapping.$name
  if (!(Test-Path $src)) { Write-Output "[SKIP] $src (not found)"; continue }
  $dstDir = Split-Path $dst
  if ($DryRun) { Write-Output "[DRY] move $src -> $dst" }
  else {
    New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
    Move-Item -Force -Path $src -Destination $dst
    Write-Output "[MOVE] $src -> $dst"
  }
}
