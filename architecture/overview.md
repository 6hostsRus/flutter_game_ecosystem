# Architecture Overview (V1)

## Stack
- **Flutter** for cross‑platform UI and build tooling (iOS/Android).
- **Flame** game engine with **Forge2D** bridge for physics‑based templates.
- **google_mobile_ads** for monetization (rewarded/interstitial/banner).
- **Local DB**: **Isar** (fast, zero‑copy) or **Hive**. 
- **Cloud Sync (optional)**: **Firebase** (Auth + Firestore/Storage) or **AWS Amplify** later.

## Package Layout (monorepo suggestion)
```
packages/
  game_core/                # shared systems + types
  game_characters/          # character domain (stats, anims, physics)
  game_items/               # items/inventory/powerups
  game_controls/            # input abstraction + virtual controls
  game_ads/                 # ad orchestration (rewarded/interstitial/banner)
  game_db/                  # save system + (optional) cloud sync
  template_endless_runner/  # ready-to-skin game template
  template_topdown_shooter/ # ready-to-skin game template
  template_match3/
  template_physics_sandbox/
apps/
  runner_demo/              # demo app wiring templates + modules
  shooter_demo/
tools/
  mason_bricks/             # generators for boilerplate scenes/entities
```

## Design Principles
- **Ports & Adapters**: interfaces in `game_core`, concrete adapters in per‑platform packages.
- **Data‑driven**: scenes, levels, items defined in JSON/YAML where possible.
- **DI‑friendly**: simple service locator or `get_it` for wiring modules.
- **Deterministic core**: minimize singletons; inject clocks/random for testability.
