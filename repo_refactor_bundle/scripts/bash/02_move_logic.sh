#!/usr/bin/env bash
set -euo pipefail

DRY=0
if [[ "${1:-}" == "--dry-run" ]]; then DRY=1; fi

MAP="./repo_refactor_bundle/config/move_map.json"
if [[ ! -f "$MAP" ]]; then
  echo "Missing $MAP"; exit 1
fi

python3 - "$1" <<'PY'
import json, os, shutil, sys
dry = 1 if (len(sys.argv)>1 and sys.argv[1]=='--dry-run') else 0
m = json.load(open("./repo_refactor_bundle/config/move_map.json"))
moves = m.get("mapping", {})
for src, dst in moves.items():
    if not os.path.exists(src):
        print(f"[SKIP] {src} (not found)")
        continue
    dstdir = os.path.dirname(dst)
    if dry:
        print(f"[DRY] move {src} -> {dst}")
    else:
        os.makedirs(dstdir, exist_ok=True)
        print(f"[MOVE] {src} -> {dst}")
        shutil.move(src, dst)
PY
