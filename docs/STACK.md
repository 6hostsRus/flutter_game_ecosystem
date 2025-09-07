# Stack Overview

> Canonical consolidated architecture + stack reference. (Generated 2025-09-05T23:28:41.086052Z)

## Core Stack

-    Flutter UI + GoRouter for navigation
-    Riverpod for DI/state (ProviderScope root)
-    Analytics adapter layer with pluggable sinks
-    Isar/Drift persistence options

## Package Topology

```
packages/
  (auto-detected)
```

-
-
-
-

## Modules Index

-    [Ads Module (V1)](modules/ads.md)
-    [Characters Module (V1)](modules/characters.md)
-    [Controls Module (V1)](modules/controls.md)
-    [Database Module (V1)](modules/db.md)
-    [Items Module (V1)](modules/items.md)

## Design Principles

-    Ports & Adapters with clean boundaries
-    Data-driven definitions (levels/items)
-    Deterministic core (injectable clock/RNG)
-    Minimal singletons; prefer provider scope

## Riverpod Patterns

_See README.md#how-to-run-key-workflows_

## Folder Shape

_See README.md#how-to-run-key-workflows_

## Optional Add-ons

_See README.md#how-to-run-key-workflows_

## Custom Notes

<!-- CUSTOM:STACK_NOTES -->

_Add any team-specific architecture notes here._

<!-- END CUSTOM -->

## Deprecation Notes

Supersedes overlapping sections in `architecture/overview.md` and `README.md#how-to-run-key-workflows`.
