#!/usr/bin/env bash
set -euo pipefail

DRY=0
if [[ "${1:-}" == "--dry-run" ]]; then DRY=1; fi

# Root to search from (repo root recommended)
ROOT="."
# Globs to ignore
IGNORE_DIRS='(\.git|build|\.dart_tool)'
# Patterns to rewrite (ordered; specific → general)
declare -A MAP
# Top-level reexports
MAP["package:game_ui/nav.dart"]="package:ui_shell/nav.dart"
MAP["package:game_ui/theme.dart"]="package:ui_shell/theme.dart"
# Deep src paths
MAP["package:game_ui/src/nav/"]="package:ui_shell/src/nav/"
MAP["package:game_ui/src/theme/"]="package:ui_shell/src/theme/"

echo "== Fixing imports (game_ui -> ui_shell) =="
echo "Dry run: $DRY"

# Collect target files
readarray -t FILES < <(find "$ROOT" -type f -name "*.dart" | grep -Ev "$IGNORE_DIRS" || true)

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "No .dart files found (after ignores)."
  exit 0
fi

CHANGED=0
for f in "${FILES[@]}"; do
  CONTENT=$(cat "$f")
  NEW="$CONTENT"
  for FROM in "${!MAP[@]}"; do
    TO="${MAP[$FROM]}"
    # Use perl for reliable, multiline-safe replace
    NEW=$(printf "%s" "$NEW" | perl -0777 -pe "s#\Q${FROM}\E#${TO}#g")
  done
  if [[ "$NEW" != "$CONTENT" ]]; then
    if [[ $DRY -eq 1 ]]; then
      echo "[DRY] would update: $f"
    else
      printf "%s" "$NEW" > "$f"
      echo "[FIXED] $f"
    fi
    CHANGED=$((CHANGED+1))
  fi
done

echo "Files updated: $CHANGED"
echo "Tip: run 'melos run analyze' or 'dart analyze' next."
