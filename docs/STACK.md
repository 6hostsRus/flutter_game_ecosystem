# Stack Overview

> Canonical consolidated architecture + stack reference. (Generated 2025-09-04)

## Core Stack

-    Flutter UI + GoRouter for navigation
-    Flame (action scenes) + optional Forge2D physics
-    Riverpod for DI/state (ProviderScope root)
-    Isar (primary embedded persistence) or Drift (relational needs)
-    Analytics adapter layer (core services) with pluggable sinks (Debug, GA4, etc.)
-    Feature flags via `--dart-define` into `AppConfig`
-    Live-Ops event model powering categories (boosts, dailies)

## Package Topology (Planned / Partial)

```
packages/
  services/               # core services: wallet, offers, analytics, monetization ports
  core_services_isar/     # optional persistence impl
  analytics_firebase_adapter/ # analytics sink impl
  (future) game_ui/       # shared widgets, theming tokens
  (future) game_scenes/   # Flame scenes (platformer, survivor, etc.)
examples/
  demo_game/              # integration reference
```

## Design Principles

-    Ports & Adapters: interfaces in service/core packages, concrete adapters per integration.
-    Data-driven definitions (levels/items) via JSON/YAML where possible.
-    Deterministic core: injectable clocks & RNG for testability.
-    Minimal singletons; prefer provider scope scoping.
-    Re-skin friendly templates; isolate game-specific logic from core modules.

## Monetization Layer

-    `MonetizationGatewayPort` defines SKU listing, availability, checkout, restore, and purchase stream.
-    `InAppPurchaseMonetizationAdapter` (currently using local stub of `in_app_purchase`).
-    Roadmap: integrate real `in_app_purchase` plugin behind feature flag `USE_REAL_IAP`.
-    Future: Ads orchestration (rewarded/interstitial) unified under OffersService.

## Live-Ops & Economy (Planned)

-    Wallet provider centralizes currency balances.
-    Event-based boosts (time-bounded multipliers) consumed by categories.
-    Sync strategy: local-first (Isar) with optional cloud reconciliation.

## Testing Strategy

-    Unit tests on port→adapter mapping (e.g., purchase status translation).
-    Provider override tests for economy & offers flows.
-    Golden tests for UI shells (menus, upgrade panels).
-    Simulation tests for idle/survivor loops (deterministic ticks).

## Conventions

-    Ports: `<domain>_port.dart`
-    Adapters: `<integration>_adapter.dart`
-    Factories: `<domain>_factory.dart`
-    Fakes (test): `fake_<dependency>.dart`
-    Manifest: `packages/manifest.yaml` authoritative list

## Open Gaps / TODOs

-    Real store plugin integration & parity guard script.
-    Economy & profile store finalized ports.
-    Metrics automation (coverage, package counts) into `docs/METRICS.md` (DONE).
-    Consolidated workflow summary doc (see `docs/WORKFLOWS.md`) (DONE).
-    Logging & analytics event conventions (see `docs/LOGGING.md`).

## Deprecation Notes

Supersedes overlapping sections in `architecture/overview.md` and `README_unified_stack.md`.
