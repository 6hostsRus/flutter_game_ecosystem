
Param([switch]$DryRun)
$files = @{
  "packages/ui_shell/lib/src/nav/game_nav_scaffold.dart" = "/* TODO(arch): Implement GameNavScaffold per AI_COPILOT_STUBS.md */`nlibrary ui_shell_nav;"
  "packages/ui_shell/lib/src/nav/nav_items.dart" = "/* TODO(arch): Define NavEntry model per AI_COPILOT_STUBS.md */`nlibrary ui_shell_nav_items;"
  "packages/services/lib/economy/economy_port.dart" = "/* TODO(arch): Define EconomyPort per AI_COPILOT_STUBS.md */`nlibrary services_economy_port;"
  "packages/services/lib/save/profile_store.dart" = "/* TODO(arch): Define profile store interfaces per AI_COPILOT_STUBS.md */`nlibrary services_profile_store;"
  "packages/providers/lib/registry/feature_registry.dart" = "/* TODO(arch): Implement feature registry per AI_COPILOT_STUBS.md */`nlibrary providers_feature_registry;"
}
foreach ($k in $files.Keys) {
  if (Test-Path $k) { Write-Output "[EXISTS] $k"; continue }
  $dir = Split-Path $k
  if ($DryRun) { Write-Output "[DRY] create $k" }
  else {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $files[$k] | Out-File -Encoding UTF8 -FilePath $k
    Write-Output "Created stub: $k"
  }
}
if ($DryRun) { Write-Output "[DRY] copy stubs/AI_COPILOT_STUBS.md to packages/" }
else { Copy-Item -Force stubs/AI_COPILOT_STUBS.md packages/ -ErrorAction SilentlyContinue }
