#!/usr/bin/env bash
set -euo pipefail

# Create a light ZIP bundle of the repository suitable for handing to an AI
# reviewer. The bundle includes only tracked files from the current HEAD
# (using git archive) and strips a few common pub/build artifacts like
# pubspec.lock and .packages to avoid leaking lockfiles and environment
# specific information.
#
# Usage:
#   tools/create_light_bundle.sh [-o output.zip]
#
# Output defaults to: project-light-bundle-YYYYmmdd-HHMMSS.zip in the repo root.

OUT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o|--output)
      OUT="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [-o output.zip]"
      exit 0
      ;;
    *)
      echo "Unknown arg: $1" >&2
      echo "Usage: $0 [-o output.zip]"
      exit 2
      ;;
  esac
done

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)
cd "$ROOT_DIR"

if [ ! -d .git ]; then
  echo "This script must be run from inside a git repository root." >&2
  exit 1
fi

if [ -z "$OUT" ]; then
  ts=$(date +"%Y%m%d-%H%M%S")
  repo_name=$(basename "$(pwd)")
  OUT="$ROOT_DIR/${repo_name}-light-bundle-$ts.zip"
fi

echo "Creating git archive of tracked files..."
# Use a prefix to avoid files being at the zip root; this keeps path context.
prefix="${repo_name}/"

git archive --format=zip --prefix="$prefix" HEAD -o "$OUT"

# Remove common lock/metadata files we don't want in the light bundle.
# These will only be present if they are tracked. Use zip -d which is safe
# to run even if the entry does not exist (it will print a warning but exit 0).
remove_paths=(
  "${prefix}pubspec.lock"
  "${prefix}.packages"
  "${prefix}package_config.json"
  "${prefix}.dart_tool/*"
  "${prefix}.flutter-plugins"
  "${prefix}.flutter-plugins-dependencies"
)

for p in "${remove_paths[@]}"; do
  # zip -d returns non-zero if nothing matched; ignore errors to keep flow simple
  zip -d "$OUT" "$p" >/dev/null 2>&1 || true
done

echo "Light bundle created: $OUT"

exit 0
