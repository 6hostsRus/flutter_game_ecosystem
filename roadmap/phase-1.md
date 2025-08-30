# Phase‑1 Plan — Ship One Game + Core Pack (2–3 weeks of focused build)

## Goal
Release a small, polished **Endless Runner** using the v1 modules, while establishing reusable packages.

## Deliverables
- `game_controls` v1 (gesture + virtual stick/button)
- `game_ads` v1 (rewarded/interstitial + caps)
- `game_db` v1 (local save, versioned)
- `game_characters` v1 (player state machine, basic enemy/hazard)
- `game_items` v1 (coins, 2–3 powerups)
- `template_endless_runner` playable
- Demo app `runner_demo` hooked to modules

## Milestones
1. **Day 1–2**: Repo + packages scaffold; controls + characters skeletons; runner scene up.
2. **Day 3–4**: Items & pickups; basic segment spawner; death & game‑over loop.
3. **Day 5**: Ads wrapper + placements (rewarded retry, interstitial on game‑over).
4. **Day 6**: Save system (coins/skins/settings); shop stub.
5. **Day 7**: Polish, SFX hooks, perf pass; release build + store checklist.

## Store Checklist (abridged)
- App ID, icons, privacy forms, ad ids, content rating, screenshots, test devices.
