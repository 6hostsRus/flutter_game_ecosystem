import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('route registry spec matches source tabs', () {
    final specFile = File('tools/route_spec/route_registry.json');
    expect(specFile.existsSync(), true);
    final spec = jsonDecode(specFile.readAsStringSync()) as Map;
    final tabs = (spec['tabs'] as List)
        .map((e) => (e as Map)['widget'])
        .cast<String>()
        .toList();
    final appSrc = File('examples/demo_game/lib/main.dart').readAsStringSync();
    final tabRegex =
        RegExp(r'GameTab\.([a-zA-Z0-9_]+): \(_\) => const ([A-Za-z0-9_]+)\(');
    final found = <String>[];
    for (final m in tabRegex.allMatches(appSrc)) {
      found.add(m.group(2)!);
    }
    expect(found.length, tabs.length, reason: 'Mismatch tab count');
    expect(found.toSet(), tabs.toSet(), reason: 'Mismatch tab widget names');
  });
}
