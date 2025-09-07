/// Minimal schema validator placeholder for game_core.
/// TODO: Replace with json_schema2 or a vetted validator when approved.

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class GameCoreSchemaValidator {
  static const String _base = 'packages/game_core/assets/schemas/';

  /// Loads a bundled schema (by file name, e.g., 'economy.schema.json').
  static Future<Map<String, dynamic>> loadSchema(String schemaFileName) async {
    final path = '$_base$schemaFileName';
    final raw = await rootBundle.loadString(path);
    return json.decode(raw) as Map<String, dynamic>;
  }

  /// Placeholder validation: ensures required top-level keys exist if provided.
  /// Returns a list of errors (empty means pass).
  static List<String> validate(
    Map<String, dynamic> data, {
    Map<String, dynamic>? schema,
    List<String> requiredKeys = const [],
  }) {
    final errors = <String>[];
    for (final key in requiredKeys) {
      if (!data.containsKey(key)) {
        errors.add('Missing required key: $key');
      }
    }
    // NOTE: This is a placeholder. For real validation, integrate a JSON Schema library.
    return errors;
  }
}
