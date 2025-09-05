import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

// Ensures detection logic would flag a mismatch if a tab were removed.
void main() {
  test('route registry negative simulate removal', () {
    final spec = jsonDecode(File('../../tools/route_spec/route_registry.json')
        .readAsStringSync()) as Map;
    final tabs = (spec['tabs'] as List)
        .map((e) => (e as Map)['widget'])
        .cast<String>()
        .toList();
    expect(tabs.length >= 2, true,
        reason: 'Need at least two tabs for negative test');
    final mutated = [...tabs]..removeLast();
    // Simulate comparison logic (set equality) should detect difference.
    final mismatch = tabs.toSet().difference(mutated.toSet()).isNotEmpty ||
        mutated.toSet().difference(tabs.toSet()).isNotEmpty;
    expect(mismatch, true, reason: 'Expected mismatch when a tab is removed');
  });
}
