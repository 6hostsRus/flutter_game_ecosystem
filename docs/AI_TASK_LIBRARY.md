# AI Task Library (Open Items Only)

Reusable task blueprints that are still active. Completed tasks have been moved into `CHANGELOG.md` under dated sections.

Note: Before executing any task from this library, follow the standard steps in `docs/AI_TASK_CHECKLIST.md`.

## How to use this library

-    Start with the standard execution steps in `docs/AI_TASK_CHECKLIST.md`.
-    To create or extend this library, use the prompt in `docs/AI_TASK_LIBRARY_PROMPT.md` and then update this file accordingly.

---

## Open Tasks (current)

The PoC work is consolidated on a single feature branch `feat/config-runtime-unify-v1` and
will be progressed there. Completed items have been moved to `CHANGELOG.md` and the
reconciliation file. The items below are still open or partially complete and are
managed from the feature branch rather than separate per-package PRs unless reviewers
request focused PRs.

### ConfigRuntimeUnify (P1) — In progress (feature branch PoC)

Purpose: Unify `packages/config_runtime` usage across the monorepo. The PoC changes
for `packages/providers`, `packages/services`, and `packages/shared_utils` are on
`feat/config-runtime-unify-v1` and have been validated locally (analyze + tests).

Current scope on feature branch:

-    Normalized Loader provider signatures in `packages/providers`.
-    Added global analytics accessor in `packages/services` (`AnalyticsPort` /
     `setGlobalAnalyticsPort` / `getGlobalAnalyticsPort`).
-    Updated `packages/shared_utils` `unawaited()` to prefer routing unawaited errors to
     the global analytics sink, falling back to NDJSON if unavailable.

Validation performed (local):

-    `melos bootstrap` succeeded (18 packages bootstrapped).
-    `melos run analyze` reported "No issues found" across the repo.
-    Per-package `flutter test` / `dart test` executed for packages with tests: All passed.

Notes:

-    Per the owner's instruction, no new focused PRs will be created at this time. Work
     will continue on `feat/config-runtime-unify-v1`. If reviewers request smaller PRs
     later, the branch can be split into focused PRs.

---

## Next Tasks (backlog)

-    Add gated Idle demo screen to `examples/demo_game` and document its enablement.
-    Implement a shared_preferences SaveDriver adapter with tests (follow-up, non-blocking).

---

For previously completed work and the full archive of reconciled tasks see `CHANGELOG.md`.

1. Create a GitHub PR: title `chore: centralize unawaited handler and demo wiring`.
2. In PR description include testing steps, the CI run link, and a note about the
   NDJSON fallback being temporary.

Validation:

-    PR created and assigned reviewers.

### EMERGENCY: Prepare cleanup branch (P0)

Purpose: Quickly prepare a focused branch that removes tracked generated files, updates ignores, and replaces obsolete forwarders so the repo is clean and CI will run reliably. This is an emergency task to be executed only when CI is failing due to tracked/generated artifacts or stale forwarders.

Steps (safe, repeatable):

1. Create a new local branch off `chore/update-docs-and-tech-data` named `emergency/cleanup-generated-files`.
2. Run a read-only audit to list tracked files that match the common generated/ephemeral patterns:
     - Patterns: `.dart_tool/`, `**/.symlinks/`, `**/flutter/ephemeral/`, `build/`, `*.stamp`, `.dart_tool/package_config_subset`, `examples/**/generated_plugins.cmake`.
     - For each match, inspect whether the file is intentionally tracked (IDE/project files) or clearly generated.
3. For truly generated files (ephemeral/symlink/plugin artifacts, build outputs):
     - Remove them from the index but keep locally: `git rm --cached <path>` (or use `git ls-files -z | xargs -0 git rm --cached --ignore-unmatch` for batch).
     - Add appropriate ignore patterns to the repo `.gitignore` files (top-level and per-example where relevant).
4. For per-package forwarders (example: `examples/demo_game/lib/src/unawaited.dart`) that now duplicate `package:shared_utils`:
     - Search repo for imports of the forwarder (e.g., `import 'package:examples_demo_game/src/unawaited.dart'` or `export '.*unawaited'`).
     - Replace usage with `package:shared_utils/shared_utils.dart` (or the canonical export path) and remove the forwarder file.
     - If replacements span many packages, batch the edits and keep changes per-package to make review easier.
5. Run repo bootstrap and static checks:
     - `melos bootstrap`
     - `melos run analyze`
     - `melos run test` (or run affected package tests first to narrow failures)
6. If analyzer/tests are clean, commit the cleanup with a clear message: `chore(repo): remove tracked generated files and obsolete forwarders` and push the branch: `git push --set-upstream origin emergency/cleanup-generated-files`.
7. Create a short PR (title: `emergency: cleanup generated files and forwarders`) and link to the failing CI run(s); mark as emergency and request expedited review.

Validation:

-    `melos run analyze` reports no new analyzer errors.
-    CI pipeline for the previously failing runs now reaches the testing stage (or at least proceeds past the golden-failure step).
-    All replaced imports resolve and app builds (locally or via CI) without missing symbols.

Notes / safety:

-    Prefer `git rm --cached` so local developer copies remain intact and no one loses files.
-    If uncertain about a file, move it to an `archive/` folder in the branch rather than deleting it outright.
-    Keep each change small and focused: one commit for `.gitignore` updates, one commit for removals, one commit for forwarder replacements.

### Repo cleanup scan: find and remove outdated files

Purpose: Review the codebase for files that are now stale due to recent refactors
(forwarders removed, docs moved, bricks, generated artifacts), and either remove or
move them to `archive/`.

Suggested first-pass candidates (investigate each):

-    `docs/game_ecosystem_categories/MERGE_INSTRUCTIONS.md` (deleted — already removed by commit)
-    `docs/game_ecosystem_categories/README.md` (deleted — already removed by commit)
-    Any per-package forwarders that were made obsolete (for example, a local
     `examples/demo_game/lib/src/unawaited.dart` forwarder) — verify and delete.
-    Stale plugin symlink directories inside `examples/demo_game/ios/.symlinks` and
     `windows/flutter/ephemeral` — these are generated and should not be in git; verify .gitignore.
-    `.dart_tool/package_config_subset` files under packages (safe to ignore, but can be removed from git if present)

Steps:

1. Run a repo search for likely forwards and duplicates (patterns: `export '.*unawaited'`, `// ignore: unawaited_futures`, `__brick__`, `__generated__`, `ephemeral`, `.dart_tool` checked in files).
2. For each candidate file:
     - Confirm it is not required by any package (search for imports/usages).
     - If unused, move it to `archive/` or delete with a commit referencing the change.
3. Run `melos bootstrap`, `melos run analyze`, and `melos run test` to confirm no regressions.

Validation:

-    Clean PR removing or archiving stale files with tests passing and analyze green.

---

Add these tasks to backlog and assign owners as appropriate.

---

## ConfigRuntimeUnify (P1)

Purpose: Unify the `config_runtime` API across packages and migrate consumers incrementally so the repo uses a single canonical runtime.

Steps:

1. Create a migration plan and present as numbered options (e.g., 1. providers-first, 2. examples-first, 3. parallel per-package PRs). Choose one option before editing.
2. Proof-of-concept: Migrate `packages/providers` to the new `config_runtime` exports in a single, small PR; include `melos bootstrap` + `melos run analyze --scope packages/providers` validation.
3. Sequentially open per-package PRs following the chosen order; each PR must include a smoke test and `change-class: refactor` header.
4. Add deprecation wrappers in `config_runtime` where needed to maintain backward compatibility for one release.
5. After all packages are migrated, run full `melos run analyze` and a representative `melos run test` matrix; update `CHANGELOG.md` and `docs/AI_TASK_RECONCILIATION.md`.

Validation:

-    `melos run analyze` and `melos run test` pass for migrated packages.
-    Examples build and run (or a smoke matrix demonstrates no missing runtime errors).

Notes:

-    Keep each package PR minimal and reversible; prefer many small PRs over one large PR.

---

## RemoveForwardersAndCanonicalizeExports (P1)

Purpose: Remove local forwarder files that duplicate canonical packages (for example `shared_utils`) and update imports to the canonical package exports.

Steps:

1. Run a repo search for forwarder patterns (exports that re-export another package or local forwarders named `unawaited`, `shared_utils`, etc.).
2. Create a per-package PR that replaces local imports with `package:shared_utils/shared_utils.dart` (or the canonical path) and removes the forwarder file.
3. Run `melos bootstrap`, `melos run analyze --scope <pkg>`, and `melos run test --scope <pkg>` before merging.
4. If many packages are affected, batch into small groups and include a migration README in the first PR.

Validation:

-    Per-package analyzer and tests pass after replacements.
-    No dangling imports or missing symbols in examples.

Notes:

-    Prefer moving a forwarder to `archive/` before deleting if unsure.

---

## FixSchemaValidatorTool (P0)

Purpose: Repair `tools/schema_validator` so it runs locally and in CI (fix missing deps, ensure executable entry, and add CI job).

Steps:

1. Reproduce locally: `melos bootstrap` then `dart run tools/schema_validator/bin/validate_configs.dart` and capture errors.
2. Update `tools/schema_validator/pubspec.yaml` with required deps (e.g., `json_schema2`) and a proper `environment:` sdk line if missing.
3. Add a smoke test and include it in `melos run test` for that package.
4. Add a CI job that runs `melos bootstrap` and the validator in `--dry-run` mode, then a full run once stable.

Validation:

-    `dart run tools/schema_validator/bin/validate_configs.dart` runs locally and in CI without missing package errors.
-    CI job completes successfully when validation is enabled.

Notes:

-    If `json_schema2` or other deps cause conflicts, pin compatible versions and update lockfiles.

---

## PlatformTargetsRestrict (P2)

Purpose: Restrict active development to Android and iOS only for the monorepo. Defer desktop (Windows/Linux) and web support until a future phase; keep macOS planned but gated for a later milestone.

Steps:

1. Update repo documentation (README.md and examples) to state supported targets: Android and iOS. Note macOS as "planned".
2. Adjust CI workflows to avoid running web, windows, and linux tests/builds. Ensure Android and iOS-related tests continue to run.
3. Add a short migration note in `docs/WORKFLOWS.md` describing how to re-enable additional targets later (feature flag + CI matrix changes).

Validation:

-    CI jobs only run Android/iOS checks for day-to-day pipelines.
-    Developers can still run platform-specific builds locally for other platforms but CI will not validate them until re-enabled.

Notes: This task is low-risk but requires coordinating CI changes; it does not delete platform code.

---

## BranchingPolicyPlan (P1)

Purpose: Define a branching policy that blocks direct pushes to `main`, requires merges to `main` to originate from `/stage`, and establishes `/dev` as the integration branch for feature development workflow.

Steps:

1. Draft a branching model document and add it to `docs/WORKFLOWS.md` describing:

     - `/feature/*` branches for working features; multiple `/feature` branches may be squashed or merged together as part of a feature series.
     - `/dev` branch as the main development integration branch where feature branches are merged once review passes.
     - `/stage` branch as a pre-release integration branch used for acceptance testing; only fully green CI runs are merged into `/stage`.
     - `main` is protected: direct merges to `main` are blocked. Only PRs merging `/stage` -> `main` are allowed and must have passing CI/CD and required approvals.

2. Implement branch protection rules on GitHub (or your Git host):

     - Protect `main`: require status checks, disallow direct pushes, require PR reviews.
     - Protect `stage`: require CI checks and approvals before merging into `main`.
     - Optionally protect `dev` with lighter checks.

3. Create a sample merge workflow (docs + template PR) showing how multiple `/feature` branches are consolidated, merged to `/dev`, tested, then promoted to `/stage` and finally to `main`.

Validation:

-    Branch protection setup is in place on the repository.
-    A small demo PR flow (feature -> dev -> stage -> main) is executed successfully in a test or staging repo.

Priority: P1 — this is a high priority governance task to prevent accidental direct merges to `main`.
