// build_symbol_map.dart
// Generates a JSON symbol map for a given Dart library by scanning public APIs.
// For our use, we target the real in_app_purchase package when present.
// Usage:
//   dart run tools/build_symbol_map.dart --package in_app_purchase --out docs/metrics/in_app_purchase_symbols.json

import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final pkg = _argValue(args, '--package') ?? 'in_app_purchase';
  final out = _argValue(args, '--out') ?? 'docs/metrics/${pkg}_symbols.json';

  // Minimal heuristic: parse the package/lib directory and list Dart filenames and class/enum names.
  // In CI where the real plugin isn't installed, this will produce an empty map gracefully.
  final libDir = Directory('packages/$pkg/lib');
  final result = <String, dynamic>{
    'package': pkg,
    'generated': DateTime.now().toUtc().toIso8601String(),
    'files': <String, dynamic>{},
  };
  if (!libDir.existsSync()) {
    stdout.writeln('Package lib not found: ${libDir.path} (skipping).');
    File(out).writeAsStringSync(jsonEncode(result));
    return;
  }
  for (final f in libDir.listSync(recursive: true)) {
    if (f is File && f.path.endsWith('.dart')) {
      final content = f.readAsStringSync();
      final classes = _matchAll(content, RegExp(r'class\s+(\w+)'));
      final enums = _matchAll(content, RegExp(r'enum\s+(\w+)'));
      result['files'][(f.path.replaceFirst('packages/$pkg/', ''))] = {
        'classes': classes,
        'enums': enums,
      };
    }
  }
  final file = File(out);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(result));
  stdout.writeln('Wrote $out');
}

String? _argValue(List<String> args, String name) {
  final i = args.indexOf(name);
  if (i == -1 || i + 1 >= args.length) return null;
  return args[i + 1];
}

List<String> _matchAll(String content, RegExp re) {
  return [for (final m in re.allMatches(content)) m.group(1)!].toSet().toList()
    ..sort();
}
