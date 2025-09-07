# Schema Validation Guide

This guide shows two ways to validate content pack data against the in‑core schemas.

-    CLI (full JSON Schema validation via json_schema2)
-    Runtime (lightweight checks via game_core validator)

## 1) CLI validation (recommended)

Validate a pack folder (e.g., modules/content_packs/sample_pack):

```sh
# From repo root
dart run tools/schema_validator/bin/validate_schemas.dart --input-dir modules/content_packs/sample_pack
```

The CLI uses schemas from `game_core/assets/schemas/` by default. It validates:

-    manifest.yaml (converted to JSON for validation)
-    economy.json
-    quests.json
-    scenes.yaml (converted to JSON for validation)

## 2) Runtime checks (lightweight)

In a Flutter app you can perform light checks (e.g., required top‑level keys) using the in‑core validator.

```dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:game_core/schemas/validator.dart';

Future<void> validateEconomyAtRuntime() async {
  // Load your economy file (for example, from assets or network).
  final raw = await rootBundle.loadString('assets/packs/sample_pack/economy.json');
  final data = json.decode(raw) as Map<String, dynamic>;

  // Optional: load the schema document (bundled with game_core) if you want to inspect it.
  final schema = await GameCoreSchemaValidator.loadSchema('economy.schema.json');

  // Perform minimal checks (e.g., required top‑level keys).
  final errors = GameCoreSchemaValidator.validate(
    data,
    schema: schema,
    requiredKeys: const ['currencies', 'offers'],
  );

  if (errors.isNotEmpty) {
    // Handle errors (report, throw, etc.)
    throw StateError('Economy invalid: ${errors.join('; ')}');
  }
}
```

Notes:

-    Runtime validator is intentionally light; prefer the CLI for full schema checks.
-    Schemas are bundled at `packages/game_core/assets/schemas/` and available via `rootBundle`.
