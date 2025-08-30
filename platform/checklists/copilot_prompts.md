# Copilot Prompts & Issue Generation Snippets

Use these snippets to mass‑generate tasks from checklists and keep them consistent across repos.

## 1) Create Issues from a Checklist
```
You are GitHub Copilot in a repo with a game ecosystem.
Read `platform/checklists/release_train.md` and create an issue for each unchecked `[ ]` line.
- Title: copy the line text.
- Labels: ["release-train", "store", "blocking" if it contains 'Submit', "assets" if it contains 'Icon' or 'Screenshots']
- Assignees: leave unassigned.
- Milestone: current release version.
- Body: include acceptance criteria and a short DoD.
```

## 2) Generate Store Asset Tasks
```
Create issues to produce store assets:
- iOS screenshots (6.7, 5.5, iPad) from current build scenes
- Android screenshots (phone, 7", 10")
- App icons & feature graphic
For each: include export sizes, naming convention, and where to commit (`/assets/store/`). Link to `platform/checklists/release_train.md#3-assets-matrix`.
```

## 3) Release PR Template
```
Generate a PR template named `.github/pull_request_template.md` with sections:
- Summary
- Linked Issues
- Risk
- Test Plan
- Store Impact (checklist items affected)
- Rollback Plan
```
