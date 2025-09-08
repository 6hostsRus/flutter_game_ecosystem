# Changelog

All notable changes to this project will be documented in this file.

Guidelines:

-    Keep entries concise and grouped by category.
-    Prefer linking to scripts/workflows/docs touched.
-    Use ISO dates (YYYY-MM-DD).

## [Unreleased]

-    game_core: Added core interfaces and utilities
     -    Clock (SystemClock, FakeClock)
     -    Logger (ConsoleLogger, MemoryLogger)
     -    Rng (SystemRng, DeterministicRng)
     -    SaveDriver (InMemorySaveDriver)
     -    IdleTimeService (migrated from snippets; Clock injected)
     -    CategoryRegistry (migrated from snippets; generic)
     -    AnalyticsEvents (migrated from snippets)
-    game_scenes: Added SceneDiagnostics using Logger and Rng; test covers deterministic logging
-    Docs: Updated paths to packages/game_core; reconciled task statuses

-    Tasks: Archived completed AI task library items into the changelog and pruned `docs/AI_TASK_LIBRARY.md` and `docs/AI_TASK_RECONCILIATION.md` to list only current open/partial items.

-    Snippets: Migrated small snippets and added tests/README entries
     -    platformer_player_controller -> `modules/genres/game_scenes/src/platformer/player_controller.dart` (+ tests)
     -    rpg_stats -> `modules/genres/rpg/src/stats.dart` (+ tests)
     -    ccg card serialization -> `modules/genres/ccg/lib/src/card.dart` (+ tests/README)
     -    survivor run_state -> `modules/genres/survivor/src/run_state.dart` (+ tests/README)

## 2025-09-07

Highlights

-    Semantic Parity

     -    Added matrix support to run parity for all specs under `tools/parity_spec/*.json`.
     -    Gated by manual dispatch or PR label `run-semantic-parity`; skips gracefully if the real plugin isn’t in `pubspec.lock`.
     -    Uploads per-package artifacts and posts a PR summary comment linking to artifacts.
     -    See `.github/workflows/semantic-parity.yml` and `docs/SEMANTIC_PARITY.md`.

-    Roadmap & Docs

     -    `docs/roadmap/phase-1.md`: added Pacing & Metrics (quality gates, perf thresholds, analytics presence, artifacts).
     -    Consolidated Ops docs remain canonical under `docs/automation/index.md`.

-    AI Task Library
     -    Reconciled and marked completed tasks as Done in `docs/AI_TASK_RECONCILIATION.md`.
     -    Cleaned `docs/AI_TASK_LIBRARY.md` to reflect no open items for this batch.

References: `docs/WORKFLOWS.md`, `docs/AI_TASK_RECONCILIATION.md`, `docs/SEMANTIC_PARITY.md`.

## 2025-09-06

Highlights

-    Metrics & Badges

     -    Repo and per-package shields emitted to `docs/badges/` (coverage*<pkg>.json, analytics*<pkg>.json, pkg*warn*<pkg>.json).
     -    Package READMEs wired to per-package endpoints; root README shows aggregate badges.
     -    Metrics publisher updated to generate and commit new badges. See `.github/workflows/metrics.yml` and `tools/update_metrics.dart`.

-    Testing & Reliability

     -    Migrated demo tests to stable Keys; reduced flakiness.
     -    Expanded Economy error-path and persistence tests.
     -    Added analytics contract tests and minimum presence gate.
     -    Golden guard workflow established for UI baselines.

-    Performance

     -    Perf simulation harness and thresholds added; CI checks p95 and action counts. See `.github/workflows/perf-metrics.yml` and `tools/check_perf_metrics.dart`.

-    Parity & Specs

     -    Non-blocking auto-update of stub parity spec integrated into metrics workflow.
     -    Optional semantic parity workflow added to diff real plugin vs spec and upload artifacts.
     -    Route registry/spec hash tracking surfaced. See `tools/spec_hashes.dart` and `.github/workflows/spec-hashes.yml`.

-    Docs & Workflows
     -    Consolidated stack docs workflow and docs catalog (`docs/WORKFLOWS.md`).
     -    Introduced AI Task Checklist and Library prompt; `ai_instructions.md` converted to an index.
     -    Release gates mapping doc and workflow.

References: `docs/WORKFLOWS.md`, `docs/AI_TASK_RECONCILIATION.md`, `docs/AI_TASK_LIBRARY.md`.
