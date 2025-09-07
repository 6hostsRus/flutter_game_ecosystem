// auto_update_parity_spec.dart
// Regenerates a minimal parity spec JSON from a discovered symbol map and writes
// it to tools/parity_spec/<package>.json, then runs the stub parity check.
// Usage:
//   dart run tools/auto_update_parity_spec.dart --package in_app_purchase --symbols docs/metrics/in_app_purchase_symbols.json

import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  final pkg = _argValue(args, '--package') ?? 'in_app_purchase';
  final symbolsPath =
      _argValue(args, '--symbols') ?? 'docs/metrics/${pkg}_symbols.json';
  final outSpec = 'tools/parity_spec/$pkg.json';

  final symbolsFile = File(symbolsPath);
  if (!symbolsFile.existsSync()) {
    stderr.writeln('Symbols file not found: $symbolsPath');
    exit(2);
  }
  final symbols =
      jsonDecode(symbolsFile.readAsStringSync()) as Map<String, dynamic>;
  final files = (symbols['files'] as Map<String, dynamic>? ?? {});
  final classes = <String>{};
  final enums = <String>{};
  for (final entry in files.entries) {
    final m = entry.value as Map<String, dynamic>;
    classes.addAll(
      ((m['classes'] as List?)?.cast<String>() ?? const <String>[]),
    );
    enums.addAll(((m['enums'] as List?)?.cast<String>() ?? const <String>[]));
  }
  // Minimal spec structure: classes with no required methods listed (empty arrays) and enum names present.
  final spec = <String, dynamic>{
    'generated': DateTime.now().toUtc().toIso8601String(),
    'package': pkg,
    'classes': {for (final c in (classes.toList()..sort())) c: <String>[]},
    'enums': {for (final e in (enums.toList()..sort())) e: <String>[]},
  };

  final out = File(outSpec);
  out.parent.createSync(recursive: true);
  out.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(spec));
  stdout.writeln('Wrote $outSpec');

  // Optionally run parity check to validate updated spec doesn't break gates.
  final res = await Process.run('dart', [
    'run',
    'tools/check_stub_parity.dart',
  ]);
  stdout.write(res.stdout);
  stderr.write(res.stderr);
  if (res.exitCode != 0) exit(res.exitCode);
}

String? _argValue(List<String> args, String name) {
  final i = args.indexOf(name);
  if (i == -1 || i + 1 >= args.length) return null;
  return args[i + 1];
}
