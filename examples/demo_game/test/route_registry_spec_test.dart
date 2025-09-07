import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('route registry spec matches source tabs', () {
    // When running from examples/demo_game directory, route spec lives two levels up.
    final specFile = File('../../tools/route_spec/route_registry.json');
    expect(specFile.existsSync(), true);
    final spec = jsonDecode(specFile.readAsStringSync()) as Map;
    final tabs = (spec['tabs'] as List)
        .map((e) => (e as Map)['widget'])
        .cast<String>()
        .toList();
    final appSrc = File('lib/main.dart').readAsStringSync();
    final tabRegex =
        RegExp(r'GameTab\.([a-zA-Z0-9_]+): \(_\) => const ([A-Za-z0-9_]+)\(');
    final found = <String>[];
    for (final m in tabRegex.allMatches(appSrc)) {
      found.add(m.group(2)!);
    }
    final foundUnique = found.toSet();
    expect(foundUnique.length, tabs.length, reason: 'Mismatch tab count');
    expect(foundUnique, tabs.toSet(), reason: 'Mismatch tab widget names');
  });
}
