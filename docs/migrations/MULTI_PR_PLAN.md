# Multi-PR Plan for Config Runtime Unification

Purpose: A concrete multi-PR schedule and reviewer checklist to migrate the repository from mixed `config_runtime` usage to a single canonical API, minimizing disruption.

High-level approach

-    The migration work will continue on the consolidated feature branch
     `feat/config-runtime-unify-v1`. This branch holds the PoC and subsequent
     incremental package changes. The feature-branch-first approach improves
     visibility and reduces PR churn; focused per-package PRs can be created from
     this branch on request.

Phases (feature-branch progression)

Phase 0 - Prep

-    Emergency cleanup (if needed) — remove tracked generated files and update .gitignore.
-    Docs & process — migration plan and PR template (already present).

Phase 1 - Core infra (PoC applied on feature branch)

-    `packages/providers` — PoC changes applied on branch.
-    `packages/services` and `packages/shared_utils` — analytics accessor and `unawaited` integration applied on branch.

Phase 2 - Game Core & Genres

-    `packages/game_core` and `modules/genres/*` — migrate incrementally on the feature branch, one genre at a time.

Phase 3 - Examples & Goldens

-    `examples/demo_game`  final integration and golden-test validation; address deterministic fonts early.

Note on goldens for this migration:

-    For the purposes of the ConfigRuntimeUnify migration we'll skip running
     `examples/demo_game` golden tests as part of the per-package validation. The
     golden harness requires a targeted refactor (deterministic font loading,
     CI-only shims) which will be implemented in a follow-up change. In PR notes
     mark goldens as "SKIPPED - to be refactored later" so reviewers are aware.

Per-feature-branch checklist (updates for PR #1)

-    PR #1 title: `feat(config-runtime): unified migration PoC + batch` (feature branch PR).
-    Include a `docs/migrations/PR_1_SUMMARY.md` file that is updated as packages are migrated with per-package analyze/test outputs.
-    For each package change committed to the feature branch, run and attach analyzer/test outputs. Recommended commands (these are proven in this repo):

```zsh
# bootstrap workspace
melos bootstrap

# analyze a package directly
cd packages/<pkg> && dart analyze .

# run package tests (if present)
cd packages/<pkg> && dart test

# repo-wide scripts
melos run analyze
melos run test
```

Reviewer checklist

-    Confirm analyzer and tests for packages affected in a commit are green.
-    For schema changes: validate schemas run and link to validator artifacts.
-    For examples: validate golden artifacts and check deterministic font loading.

Test runner guidance (quick reference)

Use these rules when running per-package tests locally or adding validation
instructions to PRs:

-    If the package depends on Flutter (has `flutter:` under `dependencies` or a
     `flutter_test` dev_dependency), run tests with `flutter test` from the package
     directory. Example:

```zsh
cd packages/game_core
flutter test --reporter=expanded
```

-    For pure-Dart packages (no Flutter dependency), use `dart test` from the
     package directory. Example:

```zsh
cd packages/config_runtime
dart test --reporter=expanded
```

-    You can use the repository melos scripts for workspace-level runs. Examples
     (from repo root):

```zsh
melos run analyze   # uses `melos exec -- dart analyze .` across packages
melos run test      # runs the repo test helper which uses flutter/dart appropriately

# or run tests scoped with melos exec (supported pattern):
melos exec --scope="game_core" -- flutter test --reporter=expanded
melos exec --scope="config_runtime" -- dart test --reporter=expanded
```

Add a short note in PR descriptions which runner you used (dart vs flutter) to make it easy for reviewers.

CI/GitHub actions guidance

-    Feature-branch commits should trigger CI that runs `melos bootstrap`, `melos run analyze`, and a representative test matrix. For performance, CI may sample tests but must run full analysis.

Timing & coordination

-    Keep each commit focused; use clear commit messages and small steps. If reviewers require atomic per-package PRs, create them from the feature branch snapshot.

Rollback strategy

-    Use small, revertable commits and keep deprecation shims where needed. If a commit causes CI failures, revert the commit on the feature branch and create a follow-up issue.
