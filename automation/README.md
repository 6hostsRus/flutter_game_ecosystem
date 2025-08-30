# Automation: Issues & Workflows

## Generate Issues (from unified checklist)
Artifacts already generated:
- `automation/issues.json`
- `automation/issues.csv`

### Option A — Bulk create with GitHub CLI
Prereqs: `gh auth login`

```bash
# Dry run: show titles
jq -r '.[].title' automation/issues.json

# Create issues
jq -c '.[]' automation/issues.json | while read -r issue; do
  title=$(echo "$issue" | jq -r '.title')
  body=$(echo "$issue" | jq -r '.body')
  labels=$(echo "$issue" | jq -r '.labels | join(",")')
  gh issue create --title "$title" --body "$body" --label "$labels"
done
```

### Option B — Import CSV to a GitHub Project
1. Create a new **Project (Beta)** in your org/user.
2. Use **Add items → CSV** and upload `automation/issues.csv`.
3. Map columns: *Title*, *Body*, *Labels*.

## Workflows
- `auto-label.yml`: labels issues/PRs based on title/keywords.
- `triage-release.yml`: adds `release-train` to issues created from the CSV/JSON flow.
