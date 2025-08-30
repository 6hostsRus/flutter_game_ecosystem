# AI Development Instructions (Project: Flutter Game Ecosystem)

> Purpose: Define how the AI assistant should work with you to **ship small, monetizable games fast** using a **modular Flutter/Dart ecosystem** with repeatable workflows.

## 1) Mission & North Star
- Ship quickly, learn quickly. Prefer **small playable releases** over perfect systems.
- Build **reusable libraries** (characters, items, controls, ads, db) + **reskinnable templates** (runner, shooter, match‑3, sandbox).
- Bake in **monetization & compliance** from day one.

## 2) Output & Delivery Style
- Be **direct, concise, and production-minded**. Avoid persona fluff.
- Always prefer **ready-to-use assets**: code, markdown, checklists, YAML, zips.
- When generating structures, follow the monorepo layout:
  - `packages/game_*` (core libs)
  - `templates/*` (game templates)
  - `platform/*` (policies, checklists)
  - `.github/*` (workflows, templates)
  - `automation/*` (scripts, issues.json/csv, QUICK_OPS.md)

## 3) Architecture Defaults
- **Flutter + Flame + Forge2D** for 2D games.
- **Engine-agnostic interfaces** in `game_core`; adapters in per-module packages.
- **Data-driven** configs (JSON/YAML) for items, levels, spawn tables.
- Keep core deterministic: inject time/random; avoid hidden singletons.
- Input abstraction (`game_controls`) → gestures, virtual sticks, accelerometer.
- Ads wrapper (`game_ads`) with **rewarded/interstitial** and **frequency caps**.
- Save system (`game_db`) → local driver first; pluggable **cloud sync** later.

## 4) Platform & Monetization
- **iOS vs Android**: maintain checklists; handle privacy, ATT, Data Safety.
- Monetization: place **rewarded** where pain peaks (revive/retry/+moves); **interstitial** between rounds with cooldowns.
- Maintain remote flags for ad placements and cooldowns (Firebase RC later).

## 5) GitHub Automations (operational contract)
- Use existing workflows in `.github/workflows/`:
  - CI (Flutter/Melos), golden guard, secret scanning, labeler, stale cleanup.
  - Release train, slash commands, iOS/Android upload stubs, store sync stubs.
  - Release-please (tags & notes), docsite on tags.
- Provide commands in responses when relevant (copy/paste ops):
  - `/release-candidate <x.y.z>`
  - `/screenshots ios|android`
  - `/submit-ios`
  - `/promote android internal|production [percent]`
  - `/store sync ios|android`
  - `/hotfix start <ver>` / `/hotfix release <ver>`
  - `/epic "Title" children: #1 #2 #3`

## 6) Planning & Checklists
- Author **[ ]**-style checklists so Copilot/GitHub can expand into issues.
- Keep these authoritative:
  - `platform/checklists/release_train.md` (master for both stores)
  - `platform/checklists/app_store.md` / `play_store.md`
  - `automation/issues.json` & `.csv` generated from release_train

## 7) Store Readiness
- iOS: App Privacy labels; ATT if IDFA; TestFlight flow; content rating.
- Android: Data Safety; AAB + Play App Signing; track promotions.
- Generate/refresh **assets matrix** (icons, feature graphic, screenshots).

## 8) Quality Gates
- Lint + format mandatory; fail PRs that don’t pass.
- Unit tests on logic; golden tests on UI when practical.
- Policy guard: no `dart:io` in shared packages; no `TODO` in `[Release]` PRs.

## 9) Communication Rules
- If requirements are ambiguous, **default to best-effort** and document assumptions at the top of the deliverable.
- Offer a clear “Next 3 actions” list at the end of each major reply.
- When proposing a large change, provide a **diff-friendly plan** (files to add/modify).

## 10) Versioning & Release Flow
- Conventional commits encouraged; `release-please` handles tags/notes.
- Use **release branches** `release/x.y.z` for RC; tags `vX.Y.Z` after approval.
- Prefer staged rollout on Play; fast follow with iOS after acceptance.

## 11) Security & Secrets
- Never commit secrets. Use GitHub Actions **secrets** (`secrets.example.md` as guide).
- Enforce gitleaks in CI; fail on detections.

## 12) File Generation Etiquette
- Keep responses lightweight; put heavy assets in a **zip** and link.
- Provide minimal **README** for any new folder explaining usage in 60 seconds.

## 13) What to Build Next (default priorities)
1) Strengthen `template_endless_runner` with coin economy + 3 powerups.
2) Ship ad placements (rewarded retry + interstitial on game-over).
3) Add Firebase Analytics + RC stubs (behind interface toggle).
4) Prepare store assets via screenshot workflows.

---

### Assistant Execution Checklist
- [ ] Honor this instruction set in all replies.
- [ ] Prefer module-first designs and reusable APIs.
- [ ] Generate Copilot-friendly checklists and issue payloads.
- [ ] Keep iOS/Android submission readiness in scope.
- [ ] Provide concrete “Next 3 actions” at end of deliverables.
