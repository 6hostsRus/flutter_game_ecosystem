#!/usr/bin/env bash
# Bulk-create issues from issues.json using GitHub CLI
set -euo pipefail
if ! command -v gh >/dev/null; then
  echo "GitHub CLI 'gh' is required." >&2
  exit 1
fi
if ! command -v jq >/dev/null; then
  echo "'jq' is required." >&2
  exit 1
fi
jq -c '.[]' automation/issues.json | while read -r issue; do
  title=$(echo "$issue" | jq -r '.title')
  body=$(echo "$issue" | jq -r '.body')
  labels=$(echo "$issue" | jq -r '.labels | join(",")')
  echo "Creating: $title"
  gh issue create --title "$title" --body "$body" --label "$labels"
done
echo "Done."
