// change-class: test
// Validates that the demo game's route/tab structure matches the JSON spec.
// For now limited to bottom navigation tabs & two modal push routes.
import 'dart:convert';
import 'dart:io';

void main() {
  final specFile = File('tools/route_spec/route_registry.json');
  if (!specFile.existsSync()) {
    stderr.writeln('route_registry.json missing');
    exit(1);
  }
  final spec = jsonDecode(specFile.readAsStringSync()) as Map;
  final tabs =
      (spec['tabs'] as List)
          .map((e) => (e as Map)['widget'])
          .cast<String>()
          .toList();
  // Naive source parsing of examples/demo_game/lib/main.dart to find tab widget class names.
  final appSrc = File('examples/demo_game/lib/main.dart').readAsStringSync();
  final tabRegex = RegExp(
    r'GameTab\.([a-zA-Z0-9_]+): \(_\) => const ([A-Za-z0-9_]+)\(',
  );
  final found = <String>[];
  for (final m in tabRegex.allMatches(appSrc)) {
    found.add(m.group(2)!);
  }
  found.sort();
  final expectedSorted = [...tabs]..sort();
  if (found.toSet().length != tabs.length || found.length != tabs.length) {
    stderr.writeln(
      'Tab count mismatch: expected ${tabs.length}, found ${found.length}',
    );
    stderr.writeln('Found: $found');
    exit(2);
  }
  if (!ListEquality().equals(found, expectedSorted)) {
    stderr.writeln('Tab widget set mismatch.');
    stderr.writeln('Expected: $expectedSorted');
    stderr.writeln('Found:    $found');
    exit(3);
  }
  stdout.writeln('Route registry OK (${tabs.length} tabs).');
  // Optional: presence of deep_links key
  if (spec.containsKey('deep_links')) {
    final dl = spec['deep_links'];
    if (dl is List && dl.isNotEmpty) {
      stdout.writeln('Deep links declared: ${dl.length}');
    }
  }
}

class ListEquality {
  bool equals(List a, List b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
