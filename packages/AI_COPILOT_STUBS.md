# AI-Copilot Authoring Guide for New Files

Purpose: Generate initial, minimal-yet-correct content for each stubbed file based on our hybrid architecture plan.

Inputs you have

-    The repo structure in config/proposed_structure.json
-    The provider/contract list and schemas in the PDF (sections: Monorepo Boundaries, Provider & Registry Model, Data Schemas).

General Rules

-    Follow Dart 3.7, Flutter stable, Flame + Forge2D.
-    Use Riverpod for state (hooks_riverpod for widgets when applicable).
-    Keep code modular and dependency-injected.
-    Write brief Dartdoc comments for public APIs.
-    Include TODOs with // TODO(arch): tags for future elaboration.

File-specific Prompts

-    packages/ui_shell/lib/src/nav/game_nav_scaffold.dart

     -    Implement a scaffold widget exposing: bottom nav, badge counts via a provider, and a slot for current scene content.
     -    Accept a list of NavEntry models and a selected index notifier/provider.
     -    Minimal theme tokens; no business logic.

-    packages/ui_shell/lib/src/nav/nav_items.dart

     -    Define NavEntry model: iconKey, label, sceneId or routeId, optional badgeProviderKey.
     -    Expose a factory for common tabs: home, upgrades, items, store, settings.

-    packages/services/lib/economy/economy_port.dart

     -    Define abstract class EconomyPort with award, spend, checkBalance, offerCatalog.
     -    Add error types: InsufficientFunds, UnknownCurrency.

-    packages/services/lib/save/profile_store.dart

     -    Define interface for encrypted profile slices and migrations.
     -    Document key-rotation and backup behaviors.

-    packages/providers/lib/registry/feature_registry.dart

     -    Provide read-only streams/selectors for Features and NavEntries.
     -    Modules self-register via a provider override or registration method.

-    modules/genres/survivor_like/ (skeleton)
     -    feature.dart exposes Features + Scenes per contracts.
     -    scenes/main_menu.dart, scenes/run_loop.dart minimal placeholders.

Output Expectations

-    Keep files compiling (where possible) with TODOs.
-    Do not add app secrets or vendor SDK keys.
-    Leave unit-test placeholders: \*\_test.dart with a single test('placeholder', () {}).
