// ignore_for_file: public_member_api_docs

import 'dart:convert';
import 'dart:io';

/// Minimal validation error surface for the drawer Validation tab.
class ValidationIssue {
  final String file;
  final String message;
  final int? line;
  final int? column;
  const ValidationIssue(this.file, this.message, {this.line, this.column});

  @override
  String toString() => 'ValidationIssue(file: $file, message: $message, line: $line, col: $column)';
}

class ValidationReport {
  final List<ValidationIssue> errors;
  final Map<String, dynamic>? merged; // only present if apply-on-green succeeded
  const ValidationReport(this.errors, this.merged);
  bool get ok => errors.isEmpty;
}

/// Loader helpers (replace with your actual file-system or asset loaders).
Future<Map<String, dynamic>> loadYamlAsMap(String path) async {
  final text = await File(path).readAsString();
  // Simple YAML loader proxy: allow JSON-in-YAML via a naive heuristic.
  // For real YAML, integrate 'yaml' package and convert to Map.
  if (text.trimLeft().startsWith('{')) {
    return jsonDecode(text) as Map<String, dynamic>;
  }
  // Fallback: very naive YAML to JSON-ish (expects k: v on each line).
  final map = <String, dynamic>{};
  for (final line in text.split('\n')) {
    if (line.trim().isEmpty || line.trimLeft().startsWith('#')) continue;
    final i = line.indexOf(':');
    if (i <= 0) continue;
    final k = line.substring(0, i).trim();
    final v = line.substring(i + 1).trim();
    map[k] = v;
  }
  return map;
}

Future<List<Map<String, dynamic>>> loadCsv(String path) async {
  final text = await File(path).readAsString();
  final lines = LineSplitter.split(text).toList();
  if (lines.isEmpty) return const [];
  final headers = lines.first.split(',');
  final rows = <Map<String, dynamic>>[];
  for (int i = 1; i < lines.length; i++) {
    final cols = lines[i].split(',');
    final row = <String, dynamic>{};
    for (int c = 0; c < headers.length && c < cols.length; c++) {
      row[headers[c]] = cols[c];
    }
    rows.add(row);
  }
  return rows;
}

Map<String, dynamic> deepMerge(Map<String, dynamic> a, Map<String, dynamic> b) {
  final out = <String, dynamic>{}..addAll(a);
  b.forEach((k, v) {
    if (v is Map && a[k] is Map) {
      out[k] = deepMerge(a[k] as Map<String, dynamic>, v as Map<String, dynamic>);
    } else {
      out[k] = v;
    }
  });
  return out;
}

/// Very light semantic validation (schema validation should happen separately via json-schema).
List<ValidationIssue> semanticChecks(Map<String, dynamic> merged) {
  final issues = <ValidationIssue>[];
  final tiles = (merged['tiles'] as Map?) ?? const {};
  final kinds = tiles['kinds'];
  final weights = tiles['weights'];
  if (weights is List && kinds is int && weights.length != kinds) {
    issues.add(ValidationIssue('<merged>', 'tiles.weights length (${weights.length}) must equal tiles.kinds ($kinds)'));
  }
  return issues;
}

/// Entry point used by the drawer when a pack is selected or files change.
/// - Resolves defaults → pack (and its includes/shards) → flags → device → dev
/// - Runs schema (TBD) + semantic validation
/// - Returns merged config on success, or a list of issues on failure
Future<ValidationReport> buildAndValidate({
  required String defaultsPath, // e.g., examples/configurator/config/defaults/match.defaults.yaml
  required String packIndexPath, // e.g., examples/configurator/config/packs/<id>/index.yaml
  Map<String, dynamic> flags = const {},
  Map<String, dynamic> device = const {},
  Map<String, dynamic> dev = const {},
}) async {
  try {
    final defaults = await loadYamlAsMap(defaultsPath);

    final packIndex = await loadYamlAsMap(packIndexPath);
    Map<String, dynamic> packMerged = Map.from(packIndex);

    // includes: board.yaml, loot.index.yaml, achievements.yaml
    if (packIndex['include'] is List) {
      for (final inc in (packIndex['include'] as List)) {
        final incPath = File(packIndexPath).parent.uri.resolve(inc).toFilePath();
        final incMap = await loadYamlAsMap(incPath);
        packMerged = deepMerge(packMerged, incMap);

        // loot index may reference shards
        if (inc.endsWith('loot.index.yaml')) {
          final sources = (incMap['sources'] as List?) ?? const [];
          for (final src in sources) {
            final file = src['file'] as String?;
            final key = src['key'] as String? ?? 'items';
            if (file == null) continue;
            final shardPath = File(incPath).parent.uri.resolve(file).toFilePath();
            if (!File(shardPath).existsSync()) {
              return ValidationReport([ValidationIssue(shardPath, 'Missing shard file')], null);
            }
            if (file.endsWith('.json')) {
              final shard = jsonDecode(await File(shardPath).readAsString());
              packMerged[key] = shard;
            } else if (file.endsWith('.csv')) {
              final shard = await loadCsv(shardPath);
              packMerged[key] = shard;
            } else {
              return ValidationReport([ValidationIssue(shardPath, 'Unsupported shard file type')], null);
            }
          }
        }
      }
    }

    // Merge order: defaults < pack < flags < device < dev
    final merged = deepMerge(
      deepMerge(
        deepMerge(
          deepMerge(defaults, packMerged),
          flags,
        ),
        device,
      ),
      dev,
    );

    // TODO: JSON-Schema validation (integrate a schema library or call out)
    final semantics = semanticChecks(merged);
    if (semantics.isNotEmpty) {
      return ValidationReport(semantics, null);
    }
    return ValidationReport(const [], merged);
  } catch (e) {
    return ValidationReport([ValidationIssue('<internal>', 'Exception: $e')], null);
  }
}
