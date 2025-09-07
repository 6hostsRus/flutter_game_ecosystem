// diff_parity_vs_real.dart
// Compares our parity spec (tools/parity_spec/in_app_purchase.json) against
// a symbol map produced for the real plugin (docs/metrics/in_app_purchase_symbols.json).
// Writes a diff report to docs/metrics/parity_diff_in_app_purchase.json.

import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final specPath = _argValue(args, '--spec') ?? 'tools/parity_spec/in_app_purchase.json';
  final symbolsPath = _argValue(args, '--symbols') ?? 'docs/metrics/in_app_purchase_symbols.json';
  final out = _argValue(args, '--out') ?? 'docs/metrics/parity_diff_in_app_purchase.json';

  final spec = _readJson(specPath);
  final symbols = _readJson(symbolsPath);

  final report = <String, dynamic>{
    'generated': DateTime.now().toUtc().toIso8601String(),
    'specVersion': spec['spec_version'],
    'package': spec['package'] ?? 'in_app_purchase',
    'summary': <String, dynamic>{},
    'missingClasses': <String, dynamic>{},
    'missingEnums': <String, dynamic>{},
  };

  // Build symbol sets from symbols map
  final symbolClasses = <String, Set<String>>{};
  final symbolEnums = <String, Set<String>>{};
  final files = (symbols['files'] ?? {}) as Map<String, dynamic>;
  for (final entry in files.entries) {
    final c = (entry.value['classes'] as List?)?.cast<String>() ?? const [];
    final e = (entry.value['enums'] as List?)?.cast<String>() ?? const [];
    for (final name in c) {
      symbolClasses.putIfAbsent(name, () => <String>{});
    }
    for (final name in e) {
      symbolEnums.putIfAbsent(name, () => <String>{});
    }
  }

  final specClasses = (spec['classes'] as Map).cast<String, List>();
  final specEnums = (spec['enums'] as Map).cast<String, List>();

  int missingClassesCount = 0;
  specClasses.forEach((className, members) {
    if (!symbolClasses.containsKey(className)) {
      report['missingClasses'][className] = {'members': members};
      missingClassesCount++;
    }
  });

  int missingEnumsCount = 0;
  specEnums.forEach((enumName, values) {
    if (!symbolEnums.containsKey(enumName)) {
      report['missingEnums'][enumName] = {'values': values};
      missingEnumsCount++;
    }
  });

  report['summary'] = {
    'missingClasses': missingClassesCount,
    'missingEnums': missingEnumsCount,
  };

  final outFile = File(out);
  outFile.parent.createSync(recursive: true);
  outFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(report));
  stdout.writeln('Wrote $out');
}

Map<String, dynamic> _readJson(String path) {
  final f = File(path);
  if (!f.existsSync()) return <String, dynamic>{};
  return jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
}

String? _argValue(List<String> args, String name) {
  final i = args.indexOf(name);
  if (i == -1 || i + 1 >= args.length) return null;
  return args[i + 1];
}
