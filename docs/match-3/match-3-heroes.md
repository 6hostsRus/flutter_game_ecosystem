#!/usr/bin/env markdown

# Template: Match‑3 — Heroes & Squads
Updated: 2025-09-10

**Purpose:** Leader/Support squads that modify board play via events and passives.

## Squad Model
- 1 Leader + up to 3 Supports.
- Leader: full-strength **active** skill (energy‑gated).
- Supports: **nerfed actives** (when leader style allows) + **passive boosts**.

## Hero Config (excerpt)
```yaml
hero:
  id: "ranger_a"
  class: "ranger"
  energy_color: green            # which tiles fuel the leader
  passives: ["drop_rate:+10%", "priority_swap"]
  support_skill: {id: "mini_arrow_storm", power: 0.5}
  leader_skill:  {id: "arrow_storm",      power: 1.0, cooldown: turns:4}
  affinities: { strong: ["green"], weak: ["red"] }
  equipment_slots: [head, glasses, earring, chest, hands, ring, bracelet, legs, feet]
  set_tags: ["woodland"]
```

## Integration Hooks
- `onMatch` → adjust energy yield by affinity/passives.
- `onSwap` → apply priority/influence rules (e.g., reroll target color).
- `onBoardStable` → trigger periodic support actions.

## Validation
- Passive stacking caps; no infinite energy loops.
- Leader without board skill must expose support‑active windows clearly.

## References
- See `docs/AI_OPERATIONS.md` for operational commands and validation steps.
- See `docs/AI_TASK_CHECKLIST.md` for execution cadence and review gates.
- See `docs/templates/README.md` for template conventions.
- See `docs/templates/match-3.md` for the original skeleton.
