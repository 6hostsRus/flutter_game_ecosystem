# Multi-PR Plan for Config Runtime Unification

Purpose: A concrete multi-PR schedule and reviewer checklist to migrate the repository from mixed `config_runtime` usage to a single canonical API, minimizing disruption.

High-level approach

-    Break the migration into package-scoped PRs.
-    Each PR is small, testable, and reversible.
-    First PR (PoC) is `packages/providers` (already completed locally).

Phases and PRs

Phase 0 - Prep

-    PR 0.1: Emergency cleanup (if needed) — remove tracked generated files and update .gitignore. (owner: infra)
-    PR 0.2: Docs & process — add migration plan and PR template. (owner: docs)

Phase 1 - Core infra (PoC done)

-    PR 1.1: `packages/providers` — PoC (normalize Loader providers, per-package validate). (owner: you/repo maintainer)
-    PR 1.2: `tools/schema_validator` — ensure validator uses config_runtime and add CI job. (owner: infra/tools)
-    PR 1.3: `packages/services` — migrate telemetry and telemetry adapters to new runtime. (owner: services)
-    PR 1.4: `packages/shared_utils` — canonical helpers & unawaited handler integration. (owner: shared_utils)

Phase 2 - Game Core & Genres

-    PR 2.1: `packages/game_core` — update core config interfaces to consume unified runtime (owner: game_core)
-    PR 2.2: `modules/genres/match` (one genre per PR thereafter) — migrate `match`, `idle`, `rpg`, `survivor` sequentially. (owner: genres)

Phase 3 - Examples & Goldens

-    PR 3.1: `examples/demo_game` — update demo wiring, assets/schemas, and golden test harness (deterministic fonts); upload artifacts for first run. (owner: demo)

Per-PR checklist

-    Title: `refactor(config-runtime): <package>`
-    Include `change-class: refactor` header at top of modified files.
-    Run locally and include the following in PR description:
     -    `melos bootstrap` output
     -    `melos run analyze --scope <package>` output
     -    `melos run test --scope <package>` output (or rationale if skipped)
-    Update `docs/AI_TASK_RECONCILIATION.md` with Status/Artifacts/Gaps for the PR.
-    For the first PR touching many packages, include a `docs/migrations/MIGRATION_README.md` describing the full plan.

Reviewer checklist

-    Confirm analyzer and tests for the package are green.
-    For schema changes: validate schemas run and link to validator artifacts.
-    For examples: validate golden artifacts and check deterministic font loading.

CI/GitHub actions guidance

-    Each PR should run `melos bootstrap` in CI before analyze/test steps.
-    For multi-package PRs, limit CI matrix to a sampling of packages for speed, but run full analyze.
-    Upload golden diffs artifacts for triage in the first demo PR.

Timing & coordination

-    Target each PR to be small (1-3 days of focused work). For larger packages (game_core, demo_game) allow 1-week windows and coordinate with maintainers.
-    Stagger merges to avoid overlapping refactors in the same package.

Rollback strategy

-    Each PR must be revertable; keep changes isolated to package scope.
-    If a PR causes unexpected breakage in CI, revert and file a follow-up issue that describes the blocker and next steps.
