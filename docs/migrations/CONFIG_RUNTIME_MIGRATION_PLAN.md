# Config Runtime Migration Plan (PoC + Full Migration)

Purpose: A compact, actionable migration plan to unify `packages/config_runtime` usage across the monorepo with a safe per-package, multi-PR approach.

How to use

-    Read the plan and pick one numbered option below (reply with the option number or a range like `1-2`).
-    After selecting an option, create the PoC PR using the sample PR template in `docs/migrations/POC_PR_TEMPLATE.md` and follow the Per-PR checklist.

Quick checklist (per your request)

-    Present options as numbered choices; reply with a number or range to select.
-    Run `melos bootstrap` at repo root before analysis or tests.
-    Use `melos run analyze --scope <pkg>` and `melos run test --scope <pkg>` for per-package validation.
-    Keep PRs small: 1 package or small subtree per PR.

Migration options (pick one)

1. Providers-first (recommended PoC)

     - PoC package: `packages/providers`.
     - Rationale: `providers` references `config_runtime` and touches many consumers; it's a focused surface to validate API ergonomics and deprecation wrappers.
     - Expected effort: small PoC, medium follow-ups.

2. Examples-first

     - PoC package: `examples/demo_game`.
     - Rationale: Update the demo app to the new runtime to validate runtime and asset schema loading across app-level wiring (assets, schemas).
     - Expected effort: medium (assets, goldens may need attention).

3. Parallel per-package PRs (fast, higher merge coordination)
     - PoC: pick 2 small packages (e.g., `packages/shared_utils`, `packages/game_core`) to validate approach.
     - Rationale: Moves faster but requires CI coordination and careful review to avoid mass breakage.

Recommended order (safe, incremental)

1. PoC: `packages/providers` (option 1) — validate API and deprecation wrapper pattern.
2. `tools/schema_validator` — ensure validator uses the new runtime without missing deps.
3. `packages/services` and `packages/shared_utils` — core infra packages.
4. `packages/game_core` and `modules/genres/*` (one genre at a time: `match`, `idle`, `rpg`, `survivor`).
5. `examples/demo_game` — final integration and golden-test validation.

Per-PR checklist (must include in every PR description)

-    Title prefix: `refactor(config-runtime): <short>`
-    `change-class: refactor` header at the top of modified files (where applicable).
-    `melos bootstrap` run and a short note: "bootstraped: yes".
-    Validators run:
     -    `melos run analyze --scope <pkg>` (attach result)
     -    `melos run test --scope <pkg>` (attach result or note if skipped)
-    Minimal smoke test steps for reviewers (one-liner commands).
-    Link to reconciliation: update `docs/AI_TASK_RECONCILIATION.md` with Status/Artifacts/Gaps.

PR size guidance

-    Keep PRs < 300 LOC where practical.
-    If >3 packages affected, split into separate PRs and include a migration README in the first PR describing the full plan.

Rollback & compatibility

-    Add small deprecation shims in `packages/config_runtime` where the old API surface existed. Keep shims for one release cycle to ease migration.
-    If a package cannot be migrated immediately, add a temporary adapter inside the package (small local shim) and plan a follow-up to remove it.

Validation commands (examples)

```zsh
melos bootstrap
melos run analyze --scope packages/providers
melos run test --scope packages/providers
```

CI recommendations

-    Run per-PR `melos bootstrap` in CI for the changed scope.
-    For large migrations, enable the CI matrix to validate a sampling of packages instead of full repo to speed iteration.
-    Enable artifact upload for failing golden diffs during example migration so baselines can be triaged.

Edge cases & risks

-    Golden tests and fonts: when migrating `examples/demo_game`, address deterministic font loading early.
-    Generated files tracked in examples can cause noisy diffs; run the emergency cleanup task first if CI noise is high.
-    Transitive dependency conflicts (e.g., `json_schema2`) may require pinning versions in `tools/schema_validator`.

Next steps after you pick an option

-    I will create a PoC PR using the template in `docs/migrations/POC_PR_TEMPLATE.md` for the chosen package (default: `packages/providers`).
-    I will run `melos bootstrap` and the per-package analyze/test commands and paste outputs into the PR description.
-    After PoC is merged, proceed through the recommended order with per-package PRs.

---

Files referenced

-    `docs/migrations/POC_PR_TEMPLATE.md` (sample PR template)
-    `docs/AI_TASK_RECONCILIATION.md` (update after each PR)
