// change-class: infra
// spec_hashes.dart
// Computes stable SHA-1 hashes for important spec / contract files to track
// evolution over time (parity spec, parity checker, adapter surfaces, etc.).
// Output written to stdout (Markdown table) and optionally to docs/SPEC_HASHES.md
// when RUN_MODE=write (env var) or --write flag is passed.
//
// Extend this list as new specs (e.g., route registry) are added.

import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';

final tracked = <String>[
  'tools/parity_spec/in_app_purchase.json',
  'tools/check_stub_parity.dart',
  'packages/in_app_purchase/lib/in_app_purchase.dart',
  'packages/services/core_services_isar/lib/core_services_isar/src/wallet_service_isar.dart',
  'tools/route_spec/route_registry.json',
];

void main(List<String> args) {
  // Compute hashes
  final rows = <List<String>>[];
  for (final path in tracked) {
    final f = File(path);
    if (!f.existsSync()) {
      rows.add([path, 'MISSING']);
      continue;
    }
    final bytes = f.readAsBytesSync();
    final hash = sha1.convert(bytes).toString();
    rows.add([path, hash]);
  }
  // Sort by path for stable ordering
  rows.sort((a, b) => a[0].compareTo(b[0]));

  final md = _renderMarkdown(rows);
  stdout.writeln(md);

  final write =
      args.contains('--write') || Platform.environment['RUN_MODE'] == 'write';
  if (write) {
    final mdFile = File('docs/SPEC_HASHES.md');
    final jsonFile = File('docs/metrics/spec_hashes.json');

    // Decide whether content actually changed (ignore timestamp churn)
    final existing = mdFile.existsSync() ? mdFile.readAsStringSync() : '';
    final existingRows = _parseMarkdownRows(existing);
    final changed = !_rowListsEqual(existingRows, rows);

    if (!changed) {
      stdout.writeln('No spec hash changes detected (skipping write).');
      return;
    }

    final header =
        '# Spec Hashes\n\nUpdated: ${DateTime.now().toUtc().toIso8601String()}\n\n';
    final footer = '\n\n> Generated via tools/spec_hashes.dart\n';
    mdFile.createSync(recursive: true);
    mdFile.writeAsStringSync('$header$md$footer');
    stdout.writeln('Wrote docs/SPEC_HASHES.md');

    // Emit JSON for dashboards: { "specs": [ {"path": ..., "sha1": ...}, ... ] }
    final jsonOut = {
      'updated': DateTime.now().toUtc().toIso8601String(),
      'specs': [
        for (final r in rows) {'path': r[0], 'sha1': r[1]},
      ],
    };
    jsonFile.createSync(recursive: true);
    jsonFile.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(jsonOut),
    );
    stdout.writeln('Wrote docs/metrics/spec_hashes.json');
  }
}

String _renderMarkdown(List<List<String>> rows) {
  final buf = StringBuffer();
  buf.writeln('| Spec File | SHA-1 |');
  buf.writeln('|-----------|-------|');
  for (final r in rows) {
    buf.writeln('| `${r[0]}` | `${r[1]}` |');
  }
  return buf.toString();
}

// Parse an existing markdown table to extract (path, hash) pairs.
List<List<String>> _parseMarkdownRows(String md) {
  final rows = <List<String>>[];
  for (final line in md.split('\n')) {
    final trimmed = line.trim();
    // Match lines like: | `path` | `hash` |
    final m = RegExp(
      r'^\|\s*`([^`]+)`\s*\|\s*`([^`]+)`\s*\|\s*$',
    ).firstMatch(trimmed);
    if (m != null) {
      rows.add([m.group(1)!, m.group(2)!]);
    }
  }
  // Ensure stable sorting for comparison
  rows.sort((a, b) => a[0].compareTo(b[0]));
  return rows;
}

bool _rowListsEqual(List<List<String>> a, List<List<String>> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i][0] != b[i][0] || a[i][1] != b[i][1]) return false;
  }
  return true;
}
