#!/usr/bin/env markdown

# Examples Configurator Hub
Updated: 2025-09-10

**Purpose:** A unified, hot‑reloadable demo hub that shows the *right way* to assemble engines and configs.
Use the hamburger drawer to switch engines, pick content packs, control RNG seeds, toggle telemetry, and view validation/merge diffs.

## Drawer Tabs
- **Engines:** choose runtime (match / idle / survivor / rpg).
- **Packs:** list from `config/packs/packs.index.yaml`; apply with *validate-first*.
- **Seed:** view/edit seed, reseed, copy, and honor **lockSeed** when enforced by a pack (PvP parity).
- **Telemetry:** toggle overlay (events/sec, average combo, energy/tile, cascade histogram).
- **Validation:** run schema + semantic checks on every file change; apply only on green.

## Merge Order (last write wins)
1. `config/defaults/*.yaml`
2. selected pack: `config/packs/<id>/index.yaml` and any referenced files
3. **environment flags** (remote + local)
4. per-device overrides: `config/overrides/device/<device_id>.yaml`
5. developer overrides: `config/overrides/dev/local.yaml` (gitignored)

Invalid config → **hard fail**. The app keeps the last good state and surfaces line/column errors.

## Golden Capture
One click saves merged config (post-merge JSON), seed, and a compact JSONL event log to `goldens/` (gitignored).
These are replayed in CI for deterministic verification.

## Localization (reserved)
Place strings in `strings/*.yaml` and reference by key from configs (e.g., `strings.item.shadow_cape`).

