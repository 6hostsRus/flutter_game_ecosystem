# CCG (Card-Collecting Game) module

This module contains a minimal card model used for the CCG snippets and examples.

-    `lib/src/card.dart` contains `CcgCard` with `toJson`/`fromJson`, `copyWith`, and equality/hash implementations.
-    `test/card_test.dart` exercises serialization round-trips and basic guards.

Purpose of this README: give a quick pointer for contributors who want to extend card models or add serialization formats.

Suggested small tasks:

-    Add JSON schema for the card format under `packages/game_core/assets/schemas/` if needed.
-    Add example card packs and sample serializers (YAML/JSON) in `test/fixtures`.
