// change-class: infra
// Stub Parity Check Script
// Ensures local stubs match expected critical symbols of upstream packages.
// Currently supports: in_app_purchase (TODO: add more as stubs appear)
// Usage: dart run tools/check_stub_parity.dart

import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final failures = <String>[];
  _checkInAppPurchase(failures);

  if (failures.isNotEmpty) {
    stderr.writeln('Stub parity failed (${failures.length} issues):');
    for (final f in failures) {
      stderr.writeln(' - ' + f);
    }
    exit(1);
  }
  stdout.writeln('Stub parity OK');
}

void _checkInAppPurchase(List<String> failures) {
  const stubPath = 'packages/in_app_purchase/lib/in_app_purchase.dart';
  const specPath = 'tools/parity_spec/in_app_purchase.json';
  final stubFile = File(stubPath);
  if (!stubFile.existsSync()) {
    failures.add('Missing in_app_purchase stub at $stubPath');
    return;
  }
  final specFile = File(specPath);
  if (!specFile.existsSync()) {
    failures.add('Missing parity spec JSON at $specPath');
    return;
  }
  final src = stubFile.readAsStringSync();
  final spec = jsonDecode(specFile.readAsStringSync()) as Map<String, dynamic>;

  // Collect classes & methods from source (very lightweight regex parsing sufficient for stub scale).
  final classRegex = RegExp(r'class\s+(\w+)');
  final methodRegex = RegExp(
    r'(?:Future<.*?>|Future|Stream<.*?>|Stream|void|bool|int|double|String|\w+)\s+(\w+)\s*\(',
  );
  final classesFound = <String, Set<String>>{};
  for (final match in classRegex.allMatches(src)) {
    classesFound[match.group(1)!] = <String>{};
  }
  for (final m in methodRegex.allMatches(src)) {
    final name = m.group(1)!;
    // Map method to last declared class by scanning backwards (simplified heuristic)
    final prefix = src.substring(0, m.start);
    final lastClass =
        classRegex.allMatches(prefix).map((e) => e.group(1)!).lastOrNull;
    if (lastClass != null) {
      classesFound[lastClass]!.add(name);
    }
  }

  final specClasses = (spec['classes'] as Map<String, dynamic>).map(
    (k, v) => MapEntry(k, (v as List).cast<String>().toSet()),
  );
  for (final specClass in specClasses.entries) {
    if (!classesFound.containsKey(specClass.key)) {
      failures.add('Missing class: ${specClass.key}');
      continue;
    }
    final foundMethods = classesFound[specClass.key]!;
    for (final requiredMethod in specClass.value) {
      if (requiredMethod.isEmpty) continue; // class with no required methods
      if (!foundMethods.contains(requiredMethod)) {
        failures.add('Class ${specClass.key} missing method: $requiredMethod');
      }
    }
  }
  // Enum values check
  final enumSpec = (spec['enums'] as Map<String, dynamic>);
  for (final enumEntry in enumSpec.entries) {
    final enumName = enumEntry.key;
    final requiredValues = (enumEntry.value as List).cast<String>();
    final enumRegex = RegExp('enum\\s+$enumName\\s*{([^}]+)}');
    final m = enumRegex.firstMatch(src);
    if (m == null) {
      failures.add('Missing enum: $enumName');
      continue;
    }
    final body = m.group(1)!;
    for (final v in requiredValues) {
      if (!RegExp('\\b$v\\b').hasMatch(body)) {
        failures.add('Enum $enumName missing value: $v');
      }
    }
  }
  // Parity TODO check
  if (!RegExp(r'TODO\(parity:').hasMatch(src)) {
    failures.add('Missing parity TODO tag with date in stub header');
  }
}

extension _IterableLastOrNull<T> on Iterable<T> {
  T? get lastOrNull => isEmpty ? null : last;
}
