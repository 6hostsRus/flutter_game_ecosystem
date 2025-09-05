// change-class: infra
// spec_hashes.dart
// Computes stable SHA-1 hashes for important spec / contract files to track
// evolution over time (parity spec, parity checker, adapter surfaces, etc.).
// Output written to stdout (Markdown table) and optionally to docs/SPEC_HASHES.md
// when RUN_MODE=write (env var) or --write flag is passed.
//
// Extend this list as new specs (e.g., route registry) are added.

import 'dart:io';
import 'package:crypto/crypto.dart';

final tracked = <String>[
  'tools/parity_spec/in_app_purchase.json',
  'tools/check_stub_parity.dart',
  'packages/in_app_purchase/lib/in_app_purchase.dart',
  'packages/services/core_services_isar/lib/core_services_isar/src/wallet_service_isar.dart',
  'tools/route_spec/route_registry.json',
];

void main(List<String> args) {
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
  final md = _renderMarkdown(rows);
  stdout.writeln(md);
  final write =
      args.contains('--write') || Platform.environment['RUN_MODE'] == 'write';
  if (write) {
    final out = File('docs/SPEC_HASHES.md');
    out.writeAsStringSync(
      '''# Spec Hashes\n\nUpdated: ${DateTime.now().toUtc().toIso8601String()}\n\n$md\n\n> Generated via tools/spec_hashes.dart\n''',
    );
    stdout.writeln('Wrote docs/SPEC_HASHES.md');
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
