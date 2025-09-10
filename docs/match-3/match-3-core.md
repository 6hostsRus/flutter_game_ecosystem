#!/usr/bin/env markdown

# Template: Match‑3 — Core (Config‑First)
Updated: 2025-09-10

**Purpose:** Define board mechanics and rule hooks as data. Code remains thin and reusable.

## Scope
- Grid model and spawn (aligns with `modules/genres/match/lib/src/board.dart`).
- Interaction widget (aligns with `modules/genres/match/lib/src/board_widget.dart`).
- Patterns: line3/4/5, L, T, Cross (enable/disable via config).
- Cascades, combo counter, gravity/refill, obstacles (HP/break rules).
- Event hooks for extensions (heroes, hazards, analytics).

## BoardConfig (YAML shape)
```yaml
board:
  width: 8
  height: 8
  mask: null                  # optional blocked coords
  gravity: down               # down|up|left|right
  refill: bag                 # bag|random
  rng_seed: 12345

tiles:
  kinds: 5
  weights: [1,1,1,1,1]        # spawn weights per kind
  obstacles:
    - id: stone_2x2
      type: block
      hp: 3
      spawn_chance: 0.02

matches:
  patterns:
    line3: {enabled: true}
    line4: {bonus: line_clear, power: 1}
    line5: {bonus: color_bomb, power: 1}
    tee:   {bonus: cross_clear,  power: 1}
    ell:   {bonus: corner_bomb,  power: 1}
  combo:
    base: 1.0
    per_cascade: 0.25

yields:
  energy_per_tile: 1
  soft_currency_per_tile: 1
  gem_drop:
    base_chance: 0.0005
    pity: {threshold_matches: 500, grant: 1}

events:
  onSwap:        ["rules/leader_energy.js"]
  onMatch:       ["rules/drop_rate_boost.js"]
  onCascadeEnd:  ["rules/boss_hazard.lua"]
  onBoardStable: ["rules/achievement_tick.ts"]

meta:
  version: 1
  compat: ">=1.0.0"
```

## Event Hooks
- `onSwap(board, posA, posB)`
- `onMatch(board, matchSet, context)`
- `onCascadeEnd(board, cascadeIndex, context)`
- `onBoardStable(board, context)`

## Validation
- Deterministic seeds for tests/goldens.
- No starting board with forced matches if disabled via config.
- Masked cells never spawn/clear unless an event explicitly edits them.

## References
- See `docs/AI_OPERATIONS.md` for operational commands and validation steps.
- See `docs/AI_TASK_CHECKLIST.md` for execution cadence and review gates.
- See `docs/templates/README.md` for template conventions.
- See `docs/templates/match-3.md` for the original skeleton.
