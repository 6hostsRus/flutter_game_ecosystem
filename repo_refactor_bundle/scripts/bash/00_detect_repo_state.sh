#!/usr/bin/env bash
set -euo pipefail
echo "== Detecting repo state =="
echo "pwd: $(pwd)"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then echo "Git repo detected."; else echo "Warning: not a git repo."; fi
echo "Current branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
echo "Uncommitted changes:"
git status --porcelain || true
