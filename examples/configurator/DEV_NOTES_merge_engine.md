#!/usr/bin/env markdown

# Configurator Merge & Validation Notes
Updated: 2025-09-11

## File Watching & Merge
- Watch `examples/configurator/config/**` for changes (YAML/JSON/CSV).
- On change:
  1. Determine current engine + pack (drawer state).
  2. Load base defaults for engine.
  3. Load pack `index.yaml`, resolve `include` files, load referenced shards (JSON/CSV).
  4. Load env flags, device override, dev/local.
  5. **Validate-first** (see below). If green → publish merged map to `mergeChainProvider`.

## Validation Order
- Identify schema per section:
  - `board` → `schemas/board.v1.json`
  - `loot`  → `schemas/loot.v1.json`
  - `achievements` → `schemas/achievements.v1.json`
- Run JSON-Schema validation for each section.
- Semantic checks (example):
  - `tiles.weights.length == tiles.kinds` (when weights present)
  - patterns present if enabled
  - shard file exists and parses
- On error → **hard fail**: keep last good state, show toast with file + line/col.

## Telemetry
- Engines publish events to `TelemetryBus`:
  - `{"evt":"match.swap","a":[x,y],"b":[u,v]}`
  - `{"evt":"match.match","cells":[...]}`
  - `{"evt":"match.cascade_end","cascade":n}`
- Overlay subscribes and computes:
  - events/sec, avg combo, energy/tile, cascade histogram.

## Merge Diff View
- Show left chain (defaults → pack → flags → device → dev) and the final merged JSON.
- Colorize added/changed/removed.
- Provide "Copy final JSON".

## Golden Capture
- Button writes:
  - `merged.json` (final merged)
  - `seed.txt`
  - `events.jsonl` (one JSON per line)
