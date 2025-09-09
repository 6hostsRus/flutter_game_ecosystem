# AI Task Library (Open Items Only)

Reusable task blueprints that are still active. Completed tasks have been moved into `CHANGELOG.md` under dated sections.

Note: Before executing any task from this library, follow the standard steps in `docs/AI_TASK_CHECKLIST.md`.

## How to use this library

-    Start with the standard execution steps in `docs/AI_TASK_CHECKLIST.md`.
-    To create or extend this library, use the prompt in `docs/AI_TASK_LIBRARY_PROMPT.md` and then update this file accordingly.

---

# Open Tasks (current)

This file contains the actionable tasks that are still open or partially complete. Completed tasks have been archived to `CHANGELOG.md` and are no longer listed here.

Before running any task, follow the standard execution steps in `docs/AI_TASK_CHECKLIST.md`.

---

## ExampleIntegrationUpdate (P2) — Partial

Purpose: Update `examples/demo_game` and genre modules to use new `game_core` APIs and any migrated snippets. Some demo wiring remains gated by feature flags and documentation updates.

Steps:

1. Replace old imports/usages with new `game_core` interfaces and utilities in the example and genre modules.
2. Ensure scenes build and run; adjust providers/services wiring if needed.
3. Add a short README note in the example about the new APIs and feature flags.

Validation:

-    `melos run example` runs without regressions.
-    Basic gameplay loop and save/ads/analytics hooks still function.

---

## Next Tasks (backlog)

These are smaller follow-ups that remain after the large consolidation work:

-    Example wiring: add optional Idle demo screen behind AppConfig feature flag and document it in the example README.
-    Persistence adapters: implement a shared_preferences SaveDriver adapter with tests; keep InMemory for unit tests.

---

For previously completed work and the full archive of reconciled tasks see `CHANGELOG.md`.

---

## New follow-ups added (P2)

### Fix CI golden diffs (P2)

Purpose: Resolve CI-only golden pixel diffs by ensuring deterministic fonts and capturing failure artifacts for triage.

Steps:

1. Add a deterministic font loader to the golden test harness so tests use bundled fonts instead of system fonts. Use `FontLoader` and `rootBundle.load` to load TTF assets before pumping widgets.
2. Ensure font files are added to `examples/demo_game/assets/fonts/` and referenced correctly in pubspec assets so `rootBundle` can load them during tests.
3. Add a temporary CI step to upload the golden failure folder (`examples/demo_game/test/goldens/failures/**`) as an artifact for visual triage.
4. Re-enable the CI golden tests, run once, inspect artifacts, and decide whether to (a) update CI baselines (`*_ci.png`) and commit, or (b) adjust font loading/locale to match developer output.

Validation:

-    CI run shows no pixel diffs after font loading or updated baselines.
-    Failure artifacts are available in the Actions UI for triage during the first debug run.

Notes:

-    Start with adding font loading in the test harness to address the most common cause (font/antialias differences).
-    Keep CI artifact upload enabled only while diagnosing; remove or keep as desired after resolution.

### Review metrics commit strategy (P2)

Purpose: Decide where and how automated metric updates should be created, reviewed, and merged in CI/CD. The goal is to avoid permission errors and to keep the main branches protected while ensuring metrics stay up to date.

Steps:

1. Audit current `tools/update_metrics.dart` to understand the intended changes and the files it touches (`docs/METRICS.md`).
2. Decide whether metric updates should be:
     - committed directly by CI (requires write permission and protected branch rules),
     - created via an automated PR for human review (recommended), or
     - stored as artifacts for a scheduled job that consolidates and applies them under a maintainer account.
3. For the chosen approach, document required GitHub permissions and reviewer rules. If automated merging is desired, list required branch protection exemptions and create a security plan.
4. Update CI workflow to implement the chosen approach. If using PRs, prefer `peter-evans/create-pull-request@v4` with a PAT stored in `secrets.METRICS_BOT_TOKEN` (avoid using `GITHUB_TOKEN` to bypass branch protections). If committing directly, run the commit on a controlled runner with a token scoped to the task.
5. Add tests / dry-run mode for `tools/update_metrics.dart` so CI can validate the change without committing.

Validation:

-    A run of CI where metrics would change produces either an open PR, an artifact, or a direct commit according to the chosen plan, without pipeline permission failures.
-    Documentation is updated with the approved process and permissions checklist.

Notes:

-    Start with the automated PR approach to keep protections intact and to make the process visible to reviewers.
-    Keep credentials limited in scope and rotate tokens regularly.

### Audit and fix schema validator CI step (P2)

Purpose: Fix `tools/schema_validator` so `dart run tools/schema_validator/bin/validate_schemas.dart` executes in CI without missing package errors, and decide whether to re-enable the step or continue to run it as a gated/manual check.

Steps:

1. Reproduce locally: run `dart run tools/schema_validator/bin/validate_schemas.dart` inside the repo after `melos bootstrap` and record the exact error (likely missing package dependency `json_schema2`).
2. Open `tools/schema_validator/pubspec.yaml` and ensure it declares `json_schema2` (and any other runtime deps) under `dependencies:` with compatible versions. If missing, add the dependency and run `melos bootstrap`.
3. If `tools/schema_validator` is intended to be a standalone package, ensure it has a proper `environment:` sdk constraint and an executable entry in `bin/` or `tool/` and that CI runs it from the package root (or use `dart run` from the repo root with `-P` if needed).
4. Add a small CI job that runs `melos bootstrap` for that package and runs the validator in a restricted mode first (e.g., `--dry-run`), then enable full validation once stable.
5. Add unit/smoke tests for the validator to avoid regressions; include them in `melos run test` for the package.

Validation:

-    `dart run tools/schema_validator/bin/validate_schemas.dart` runs locally and in CI without missing package errors.
-    CI job completes successfully when schema validation is enabled.

Notes:

-    If `json_schema2` has transitive constraints or platform-specific code, prefer pinning a compatible version in the validator pubspec and update lockfiles accordingly.
-    As a temporary measure, keep the CI step a no-op until the validator is fixed to avoid blocking other CI activities.

### Route shared_utils unawaited NDJSON into Analytics sink

Purpose: Replace the on-disk NDJSON fallback in `packages/shared_utils/lib/shared_utils.dart`
with a call into the repository's analytics sink so unhandled unawaited exceptions
are collected in the same place as other metrics.

Steps:

1. Update `shared_utils.unawaited` so that when `_unhandledErrorHandler` is null it
   attempts to resolve an `AnalyticsPort` (via a short-lived `ProviderContainer`)
   and call `send(AnalyticsEvent('unawaited_error', {...}))`.
2. Keep the NDJSON fallback as a last-resort if analytics is unavailable or writing fails.
3. Add tests verifying analytics sink receives events and that fallback still writes when
   analytics is not available.

Validation:

-    Unit tests in `packages/shared_utils` and `packages/providers` pass.
-    `melos run analyze` reports no new analyzer errors.

### Open PR and request review

Purpose: Push the branch `chore/update-docs-and-tech-data` (already pushed) and open a PR
with a short description summarizing the change, linking to the tests and CI results.

Steps:

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
