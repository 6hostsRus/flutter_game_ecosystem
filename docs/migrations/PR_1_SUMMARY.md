# Feature PR: feat/config-runtime-unify-v1 — PoC + migration batch

## Purpose

This file summarizes the PoC and verification artifacts currently present on the
feature branch `feat/config-runtime-unify-v1`. It is intended to be attached to
the open PR (#1) so reviewers and automation can quickly see what changed and
what was validated locally.

## High-level changes included in this branch

-    Normalized Loader provider signatures in `packages/providers` and fixed
     await/double-await patterns.
-    Added a minimal global analytics accessor in `packages/services` and
     registered the `MultiAnalytics` instance from `packages/providers`.
-    Updated `packages/shared_utils` `unawaited()` to prefer routing unawaited
     errors to the global analytics sink, with the existing NDJSON fallback
     preserved for CI/CLI environments.
-    Fixed fragile imports and typing issues in `modules/genres/match`.
-    Added docs and migration artifacts under `docs/migrations/` (plans & PR
     templates).
-    Rewrote the repository validator workflow to use a repo-local invocation of
     the validator script; validated locally ("Validation OK.").

## Verification performed locally

-    melos bootstrap: SUCCESS — 18 packages bootstrapped
-    Per-package `dart analyze` and `flutter test` for affected packages:
     -    packages/providers: analyze ✔, tests ✔
     -    packages/services: analyze ✔, tests ✔
     -    packages/shared_utils: analyze ✔, tests ✔
     -    modules/genres/match: analyze ✔, tests ✔
     -    examples/demo_game: analyze ✔, tests ✔ (goldens included)
     -    packages/game_core: analyze ✔, tests ✔
-    tools/schema_validator: "Validation OK." when run locally

## Files changed (high-level)

-    packages/providers/lib/config/providers.dart
-    packages/providers/lib/analytics/analytics_provider.dart
-    packages/services/lib/analytics/analytics_port.dart
-    packages/shared_utils/lib/shared_utils.dart
-    modules/genres/match/lib/\*\*
-    tools/schema_validator/\*\*
-    docs/migrations/\*\*

## Notes about PR workflow

-    Per the repository owner's instruction, no new focused PRs will be created at
     this time; work will continue on this feature branch and PR #1 will be updated
     as changes land. If reviewers prefer granular, per-package PRs later, those
     can be split from this branch.

## Next steps (this branch)

1. Continue migrating the next package: `packages/config_runtime` (run analyze
   & tests; apply compatibility shims where needed).
2. Keep `feat/config-runtime-unify-v1` up to date and push incremental commits
   to the branch so PR #1 reflects the ongoing work.
3. When ready, optionally split focused PRs for reviewers who prefer atomic
   diffs.

If you want me to (A) update PR #1 body directly via GitHub CLI, (B) continue
migrating the next package now, or (C) both, I inferred (C) and started by
committing this summary. I will now run the migration steps for
`packages/config_runtime` on the same branch and report results.
