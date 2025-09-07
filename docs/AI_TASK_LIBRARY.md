# AI Task Library (Open Items Only)

Reusable task blueprints that are still active. Completed tasks have been moved into `CHANGELOG.md` under dated sections.

Note: Before executing any task from this library, follow the standard steps in `docs/AI_TASK_CHECKLIST.md`.

## How to use this library

-    Start with the standard execution steps in `docs/AI_TASK_CHECKLIST.md`.
-    To create or extend this library, use the prompt in `docs/AI_TASK_LIBRARY_PROMPT.md` and then update this file accordingly.

---

# Open Tasks

## GameCoreRelocationAndConsolidation (P1)

Purpose: Normalize package layout by moving `game_core` under `packages/` and consolidating public API exports.

Steps:

1. Create `packages/game_core/` and move current `game_core` contents (lib, test, pubspec.yaml, README).
2. Update `melos.yaml` packages list to include `packages/game_core` and remove root `game_core` entry.
3. Update imports across the repo to use `package:game_core/...` consistently (no relative `../game_core`).
4. Update `.github/labeler.yml` and any workflow path filters to the new location.
5. Add `lib/game_core.dart` that re-exports stable surface (contracts, base scene lifecycle, Flame/Forge2D glue).
6. Run `melos bootstrap`, `melos run analyze`, and `melos run test`; fix breakages.
7. Update references in README and docs to the new path.

Validation:

-    All packages build/tests pass in CI.
-    No broken imports; labeler/workflows react to the new path.
-    Public API filed under `lib/game_core.dart` is documented.

---

## GameCoreInterfacesImplementation (P1)

Purpose: Implement engine-agnostic contracts listed in `game_core/interfaces.md` in accordance with Coding Standards and project goals.

Contracts to implement (initial set):

-    Clock, Rng, Logger
-    AdService, RewardBus
-    SaveDriver
-    InputSource, GameInputSnapshot
-    AnimationSet, PhysicsHandle

Steps:

1. Define interface types and minimal default implementations in `packages/game_core/lib/core/`.
2. Add unit tests (happy path + one edge) per contract; include fakes/mocks where helpful.
3. Provide adapters/shims where needed for Flame/Forge2D, guarded behind optional imports.
4. Document usage with brief examples in code comments and a `docs/` section reference.
5. Wire into an example scene (demo or genre module) to verify ergonomics.

Validation:

-    Tests pass and coverage meets policy for new files.
-    Example compiles and basic flows work (input snapshot, save roundtrip, logger output).
-    Contracts are exported via `lib/game_core.dart` and referenced in README/docs.

---

## SnippetsReconciliationToGameCore (P2)

Purpose: Audit `snippets/dart/**` and migrate reusable code into `packages/game_core` or relevant genre modules; move doc-only material to `docs/`.

Steps:

1. Inventory snippets by folder (ccg, core, idle, match, platformer, rpg, survivor) and classify:
     - Reusable utility/extension (→ game_core)
     - Genre-specific example (→ modules/genres/<...>)
     - Doc-only (→ docs/snippets/ with explanation)
2. For code migrations: add tests, adhere to Coding Standards, and expose via appropriate exports.
3. Remove or de-duplicate original snippets after migration; leave pointers in a MIGRATION.md.
4. Update any references in templates/docs to the new locations.

Validation:

-    Snippets directory size reduced; migrated items have tests.
-    Modules and game_core compile and expose new utilities.
-    Docs render updated links.

---

## TemplatesAndSchemasRefactor (P1)

Purpose: Move JSON schemas in-core and rationalize template docs.

Decision: Schemas live under `packages/game_core/assets/schemas/` with a light runtime validator API.

Steps:

1. Create `packages/game_core/assets/schemas/` and move `templates/schemas/*.schema.json` there.
2. Add a minimal runtime validator in `packages/game_core/lib/schemas/validator.dart` that loads bundled schemas and validates JSON maps (wrap `json_schema2` or a local minimal validator if policy forbids new deps).
3. Update `tools/schema_validator/` and CI workflows to point to `packages/game_core/assets/schemas/`.
4. Template docs: Move `.md` files under `templates/` to `docs/templates/` and cross-link from README.
5. Add guidance snippets demonstrating schema usage in code (e.g., loading a scene manifest) and reference from `docs/templates/`.

Validation:

-    CI schema validation passes; paths updated in tools/workflows.
-    Docs updated and linked from README How-To section.
-    Deprecated paths removed or stubbed with pointers.

---

## DocsAndOpsAlignmentForMoves (P2)

Purpose: Keep workflows and ops docs consistent with relocations.

Steps:

1. Update `docs/WORKFLOWS.md`, `docs/automation/index.md`, `ai_instructions.md` to reflect new paths/workflows.
2. Update workflow path filters (CI, metrics, parity, goldens) to include `packages/game_core/**` and schemas location.
3. Update `.github/labeler.yml` mappings.

Validation:

-    Workflows trigger as expected on changes in the new locations.
-    Ops docs remain canonical and accurate.

---

## ExampleIntegrationUpdate (P2)

Purpose: Update `examples/demo_game` and genre modules to use new game_core APIs and any migrated snippets.

Steps:

1. Replace old imports/usages with new `game_core` interfaces and utilities.
2. Ensure scenes build and run; adjust providers/services wiring if needed.
3. Add a short README note in the example about the new APIs.

Validation:

-    `melos run example` runs without regressions.
-    Basic gameplay loop and save/ads/analytics hooks still function.

---

Note: Follow `docs/CODING_STANDARDS.md` and `docs/AI_TASK_CHECKLIST.md` for each task. Use small, reviewable PRs with green CI (analyze, test, schema checks).
