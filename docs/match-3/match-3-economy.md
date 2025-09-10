#!/usr/bin/env markdown

# Template: Match‑3 — Economy & Caps
Updated: 2025-09-10

**Purpose:** Energy drives actives; end‑of‑round converts to coins/XP; gems stay scarce.

## Rules
- Energy per tile; fuels leader/support skills.
- End‑of‑round conversion: total energy → **round bonus** (coins + hero XP).
- Gems: rare; small chance on hard feats; pity timers optional.
- Coin→Energy: allowed, **rolling 24h caps** per refill slot.

## Caps (Rolling 24h)
- Refill #1: coins only.
- Refills #2..N: coins + ad watch (player-initiated).
- Premium currency or active subscription bypasses ads.
- Caps expand modestly with account level (optional).

## Drop Tables (Sketch)
```yaml
bosses:
  shadow_knight:
    first_clear: {hero_unlock: "shadow_knight"}
    table:
      guaranteed: [{coins: 500}, {xp_tokens: 50}]
      chance:
        - {item: "shadow_cape",   p: 0.08}
        - {item: "void_shard",    p: 0.05}
        - {gems: 3,               p: 0.01}
```

## Validation
- Track currency inflow/outflow; guard against inflation.
- Ensure F2P viable progression under caps.
## References
- See `docs/AI_OPERATIONS.md` for operational commands and validation steps.
- See `docs/AI_TASK_CHECKLIST.md` for execution cadence and review gates.
- See `docs/templates/README.md` for template conventions.
- See `docs/templates/match-3.md` for the original skeleton.
