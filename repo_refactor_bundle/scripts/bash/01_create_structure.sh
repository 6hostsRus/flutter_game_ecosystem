#!/usr/bin/env bash
set -euo pipefail

DRY=0
if [[ "${1:-}" == "--dry-run" ]]; then DRY=1; fi

CONF="./repo_refactor_bundle/config/proposed_structure.json"
if [[ ! -f "$CONF" ]]; then
  echo "Missing $CONF"; exit 1
fi

DIRS=$(python3 - <<'PY'
import json
cfg=json.load(open("./repo_refactor_bundle/config/proposed_structure.json"))
for d in cfg["directories"]:
    print(d)
PY
)

while IFS= read -r d; do
  if [[ -z "$d" ]]; then continue; fi
  if [[ $DRY -eq 1 ]]; then
    echo "[DRY] mkdir -p $d"
  else
    mkdir -p "$d"
    echo "Created: $d"
  fi
done <<< "$DIRS"
