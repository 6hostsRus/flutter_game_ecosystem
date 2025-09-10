#!/usr/bin/env markdown

# Template: Match‑3 — Conventions & Extension Points
Updated: 2025-09-10

**Purpose:** Where to add new content; naming rules to keep parity.

## Add New Content
- Heroes → extend `match-3-heroes.md` and add config under `templates/match-3/*/heroes/`.
- Modes  → extend `match-3-modes.md` with feature flags and seed rules.
- Economy→ extend `match-3-economy.md` (drop tables, caps).

## Naming
- Files: `match-3-<topic>.md`.
- Headings: Title‑cased; include **Purpose**, **Validation**, **References**.
- Events: `onSwap`, `onMatch`, `onCascadeEnd`, `onBoardStable`.

## PR Checklist
- Validation scenarios included.
- Links to affected configs and tasks.
- Metrics/events listed for analytics.

## References
- See `docs/AI_OPERATIONS.md` for operational commands and validation steps.
- See `docs/AI_TASK_CHECKLIST.md` for execution cadence and review gates.
- See `docs/templates/README.md` for template conventions.
- See `docs/templates/match-3.md` for the original skeleton.
