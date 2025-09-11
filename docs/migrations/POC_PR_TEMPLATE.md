# PoC PR Template: config_runtime migration

Use this template as the PR description when opening a PoC or per-package migration PR.

Title

refactor(config-runtime): migrate <package-name> to new config_runtime

Body

What/Why

-    Short summary: migrate `<package-name>` to import and use the unified `config_runtime` API so consumers follow the canonical runtime.
-    Why: reduce duplication, centralize schema assets, enable shared validation and deprecation path.

Change summary

-    Files changed (high level):
     -    `...`
-    Key edits: imports updated, minor adapter added in `packages/config_runtime` (deprecation wrapper), tests updated.

Per-PR checklist

-    [ ] `melos bootstrap` run locally: yes
-    [ ] `melos run analyze --scope <package-name>`: attached output
-    [ ] `melos run test --scope <package-name>`: attached output or note
-    [ ] Provide a short smoke test for reviewers (one-liner commands)
-    [ ] Updated `docs/AI_TASK_RECONCILIATION.md` with Status/Artifacts/Gaps

Validation output (paste below)

```
# analyzer output
# test output
```

Reviewer notes

-    If this PR touches schema files, check `packages/config_runtime/assets/schemas` for required changes.
-    If this PR touches golden tests (examples), CI will upload failure artifacts for triage.

Migration README (if first PR)

-    If this is the first migration PR, add a short `docs/migrations/MIGRATION_README.md` in the PR describing the overall plan and the list of subsequent PRs.

Rollback

-    To rollback, revert this PR and reintroduce the local adapter (if downstream consumers still rely on previous API). Follow the per-package rollback guidance in `docs/migrations/CONFIG_RUNTIME_MIGRATION_PLAN.md`.
