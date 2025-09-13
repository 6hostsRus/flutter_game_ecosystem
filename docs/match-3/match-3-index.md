#!/usr/bin/env markdown

# Match‑3 Template Bundle (Index)
Updated: 2025-09-10

**Purpose:** Index of modular Match‑3 docs. These extend the base `docs/templates/match-3.md`
with config‑first patterns that your AI copilot can consume.

## Modules
- `match-3-core.md` — Board, rules, patterns, obstacles, events (config‑first).
- `match-3-heroes.md` — Leader/Support squads, affinities, passives, equipment hooks.
- `match-3-economy.md` — Energy/coins/XP/gems, rolling caps, coin→energy, drop tables.
- `match-3-modes.md` — Puzzle/Battle/Master/Rush/Boss; fair fights + boss arcs.
- `match-3-pvp.md` — Arenas, wagers (80/20), chests, weekly→monthly→seasonal ladders.
- `match-3-subscriptions.md` — Ad‑Free / VIP / Premium Club (stacking).
- `match-3-prestige.md` — Invite‑only clubs, legacy vs seasonal titles.
- `match-3-hub.md` — Web hub, stat cards, player home & guild hall (stylized 2D UI).
- `match-3-achievements.md` — Cross‑mode challenges, ecosystem achievements.
- `match-3-conventions.md` — How to extend/submit changes, file/class naming.

## Conventions
- Keep docs **concise** and **machine‑parsable** (bullets > prose).
- Prefer **config** over code; link to schema keys and event hook names.
- Cross‑reference related docs instead of duplicating content.
- Include **Validation** sections when rules affect gameplay balance.

## References
- See `docs/AI_OPERATIONS.md` for operational commands and validation steps.
- See `docs/AI_TASK_CHECKLIST.md` for execution cadence and review gates.
- See `docs/templates/README.md` for template conventions.
- See `docs/templates/match-3.md` for the original skeleton.
