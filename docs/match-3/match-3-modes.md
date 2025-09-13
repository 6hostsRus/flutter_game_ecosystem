#!/usr/bin/env markdown

# Template: Match‑3 — Modes & Boss Arcs
Updated: 2025-09-10

**Purpose:** Distinct mode flavors, same engine via feature flags.

## Modes
- **Puzzle:** enemy throws obstacles only; tight move caps.
- **Battle:** enemy leader acts (own board or interruption turns).
- **Master/Rush:** timers/pressure; high cascade visibility.
- **Boss:** fair fights escalate to **Big Bad Boss** milestones.

## Feature Flags (examples)
```yaml
mode:
  id: "puzzle"
  enemy_ai: "hazard_only"
  move_cap: 20
  timer: null
  bonus_patterns: [line4, tee, ell]
```

## Boss Arcs
- First clear → hero unlock + transparent drop tables.
- Replay → targeted farming; pity timers for rare drops (optional).

## References
- See `docs/AI_OPERATIONS.md` for operational commands and validation steps.
- See `docs/AI_TASK_CHECKLIST.md` for execution cadence and review gates.
- See `docs/templates/README.md` for template conventions.
- See `docs/templates/match-3.md` for the original skeleton.
