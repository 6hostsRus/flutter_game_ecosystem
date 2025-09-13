# Config Runtime Migration Plan (PoC + Full Migration)

Purpose: A compact, actionable migration plan to unify `packages/config_runtime` usage across the monorepo.

Current approach (decision)

-    The PoC and subsequent migration work are being executed on a single feature branch
     `feat/config-runtime-unify-v1`. This branch contains the PoC changes (providers,
     services, shared_utils) and will be used to continue incremental migrations. The
     decision was made to favor a unified feature branch and single PR for visibility
     and easier coordination. If reviewers request split PRs later, the branch can be
     sliced into focused per-package PRs.

Quick checklist

-    Run `melos bootstrap` at repo root before analysis or tests.
-    Per-package validation (working commands used in this repository):

-    Use the repository melos scripts where appropriate, or run per-package
-    analyzer/tests directly. Examples (these work in this repo):

```zsh
# bootstrap the workspace
melos bootstrap

# analyze a package directly (preferred for per-package checks)
cd packages/<pkg> && dart analyze .

# run tests for a package (if it has a test/ directory)
cd packages/<pkg> && dart test

# repository-wide scripts (melos)
melos run analyze    # runs `melos exec -- dart analyze .` across packages
melos run test       # runs the repo test script (see melos.yaml)
```

Recommended sequence (as implemented on feature branch)

1. PoC: `packages/providers` — validated and merged into the feature branch.
2. `packages/services` and `packages/shared_utils` — core infra changes completed on
   the feature branch (analytics accessor, unawaited handling).
3. `tools/schema_validator` — ensure validator works with new runtime (fix deps).
4. `packages/game_core` and `modules/genres/*` — one genre at a time: `match`,
   `idle`, `rpg`, `survivor`.
5. `examples/demo_game` — final integration and golden-test validation.

Per-feature-branch checklist (what to attach to PR #1 as updates)

-    Title: `feat(config-runtime): unified migration PoC + batch` (PR #1 is the canonical PR).
-    Add a `docs/migrations/PR_1_SUMMARY.md` file (or update it) containing per-package
     analyze/test outputs and short notes for reviewers.
-    For each incremental commit or package change on the feature branch, run and
     paste `melos run analyze --scope <pkg>` and `melos run test --scope <pkg>` outputs
     into the PR conversation or `PR_1_SUMMARY.md`.
-    Keep commits small and comment-friendly; if a reviewer requests a focused PR for
     a package, create it from the feature branch snapshot.

PR size guidance

-    Keep changes per commit small and targeted; the feature PR is intended to hold
     the full progression of the migration, not to force reviewers to accept a single
     large monolith without context.

Rollback & compatibility

-    Add short-lived deprecation shims where needed and keep them for a single
     release cycle.
-    If a package cannot be migrated in time, add an internal shim in that package
     and schedule a follow-up to remove it.

Validation commands (examples)

```zsh
# bootstrap
melos bootstrap

# per-package analyzer (example: providers)
cd packages/providers && dart analyze .
cd packages/providers && dart test

# full repo scripts (useful for CI or broad checks)
melos run analyze
melos run test
```

CI recommendations

-    The feature branch should be the primary integration point and CI should run
     per-commit checks (bootstrap + per-package analyze + a representative test
     matrix). For performance, CI can run a sampling of packages' tests but must run
     full `melos run analyze`.

Edge cases & risks

-    Golden tests and fonts: address deterministic font loading early when migrating
     `examples/demo_game`.

Note on goldens for this migration:

-    For the purposes of the ConfigRuntimeUnify migration we'll skip running
     `examples/demo_game` golden tests as part of the per-package validation. The
     golden harness requires a targeted refactor (deterministic font loading,
     CI-only shims) which will be implemented in a follow-up change. In PR notes
     mark goldens as "SKIPPED - to be refactored later" so reviewers are aware.
-    Transitive dependency conflicts (e.g., `json_schema2`) may require pinning
     versions in `tools/schema_validator`.

Next steps

-    Continue incremental package migrations on `feat/config-runtime-unify-v1`.
-    Update `docs/migrations/PR_1_SUMMARY.md` and the feature PR body with the
     per-package verification outputs as commits land.

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
