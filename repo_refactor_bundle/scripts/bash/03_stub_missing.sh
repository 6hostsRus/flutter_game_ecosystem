#!/usr/local/bin/bash
set -euo pipefail

DRY=0
if [[ "${1:-}" == "--dry-run" ]]; then DRY=1; fi

declare -A FILES
FILES["packages/ui_shell/lib/src/nav/game_nav_scaffold.dart"]=$'/* TODO(arch): Implement GameNavScaffold per AI_COPILOT_STUBS.md */\nlibrary ui_shell_nav;\n'
FILES["packages/ui_shell/lib/src/nav/nav_items.dart"]=$'/* TODO(arch): Define NavEntry model per AI_COPILOT_STUBS.md */\nlibrary ui_shell_nav_items;\n'
FILES["packages/services/lib/economy/economy_port.dart"]=$'/* TODO(arch): Define EconomyPort per AI_COPILOT_STUBS.md */\nlibrary services_economy_port;\n'
FILES["packages/services/lib/save/profile_store.dart"]=$'/* TODO(arch): Define profile store interfaces per AI_COPILOT_STUBS.md */\nlibrary services_profile_store;\n'
FILES["packages/providers/lib/registry/feature_registry.dart"]=$'/* TODO(arch): Implement feature registry per AI_COPILOT_STUBS.md */\nlibrary providers_feature_registry;\n'

for path in "${!FILES[@]}"; do
  if [[ -f "$path" ]]; then
    echo "[EXISTS] $path"
    continue
  fi
  dir=$(dirname "$path")
  if [[ $DRY -eq 1 ]]; then
    echo "[DRY] create $path"
  else
    mkdir -p "$dir"
    printf "%s\n" "${FILES[$path]}" > "$path"
    echo "Created stub: $path"
  fi
done

if [[ $DRY -eq 1 ]]; then
  echo "[DRY] copy stubs/AI_COPILOT_STUBS.md to packages/"
else
  cp -f ./repo_refactor_bundle/stubs/AI_COPILOT_STUBS.md packages/ 2>/dev/null || true
fi
