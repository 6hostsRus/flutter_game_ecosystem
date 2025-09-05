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
    r'^\s*(?:Future<.*?>|Future|Stream<.*?>|Stream|void|bool|int|double|String|List<.*?>|Map<.*?>|Set<.*?>)\s+(\w+)\s*\(',
    multiLine: true,
  );
  final classesFound = <String, Set<String>>{};
  for (final match in classRegex.allMatches(src)) {
    final cls = match.group(1)!;
    if (_ignoredClassName(cls)) continue;
    classesFound[cls] = <String>{};
  }
  for (final m in methodRegex.allMatches(src)) {
    final name = m.group(1)!;
    final prefix = src.substring(0, m.start);
    final lastClass =
        classRegex.allMatches(prefix).map((e) => e.group(1)!).lastOrNull;
    if (lastClass != null && classesFound.containsKey(lastClass)) {
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
  // Extra classes / methods detection (excluding allowed debug helpers)
  final allowedExtraClasses = _allowedExtraClasses();
  for (final c in classesFound.entries) {
    if (!specClasses.containsKey(c.key) &&
        !allowedExtraClasses.contains(c.key)) {
      failures.add('Extra class not in spec: ${c.key}');
    } else if (specClasses.containsKey(c.key)) {
      final specMethods = specClasses[c.key]!;
      for (final m in c.value) {
        if (!specMethods.contains(m) && !_allowedExtraMethod(c.key, m)) {
          failures.add('Class ${c.key} extra method not in spec: $m');
        }
      }
    }
  }
  // Enum values check & extra detection
  final enumSpec = (spec['enums'] as Map<String, dynamic>);
  final enumDeclRegex = RegExp(r'enum\s+(\w+)\s*{([^}]+)}');
  final enumsFound = <String, List<String>>{};
  for (final em in enumDeclRegex.allMatches(src)) {
    final name = em.group(1)!;
    final body = em.group(2)!;
    final values =
        body
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
    enumsFound[name] = values;
  }
  for (final specEnum in enumSpec.entries) {
    final enumName = specEnum.key;
    final requiredVals = (specEnum.value as List).cast<String>();
    final foundVals = enumsFound[enumName];
    if (foundVals == null) {
      failures.add('Missing enum: $enumName');
      continue;
    }
    for (final rv in requiredVals) {
      if (!foundVals.contains(rv)) {
        failures.add('Enum $enumName missing value: $rv');
      }
    }
  }
  for (final found in enumsFound.entries) {
    if (!enumSpec.containsKey(found.key)) {
      if (!_allowedExtraEnum(found.key)) {
        failures.add('Extra enum not in spec: ${found.key}');
      }
      continue;
    }
    final allowed = (enumSpec[found.key] as List).cast<String>().toSet();
    for (final v in found.value) {
      if (!allowed.contains(v) && !_allowedExtraEnumValue(found.key, v)) {
        failures.add('Enum ${found.key} extra value not in spec: $v');
      }
    }
  }
  // Parity TODO check
  if (!RegExp(r'TODO\(parity:').hasMatch(src)) {
    failures.add('Missing parity TODO tag with date in stub header');
  }
}

Set<String> _allowedExtraClasses() => {
  // Add internal helper/debug classes here if ever introduced.
};

bool _allowedExtraMethod(String className, String methodName) {
  if (className == 'InAppPurchase' && methodName.startsWith('debugEmit')) {
    return true; // debug helper methods are exempt.
  }
  if (className == 'InAppPurchase' && methodName == '_emitSuccess') {
    return true; // internal helper not part of public surface.
  }
  return false;
}

bool _allowedExtraEnum(String enumName) => false;
bool _allowedExtraEnumValue(String enumName, String value) => false;

bool _ignoredClassName(String name) {
  // Filter words like 'marker' that appear in comments such as 'subclass marker'.
  const noise = {'marker'};
  return noise.contains(name.toLowerCase());
}

extension _IterableLastOrNull<T> on Iterable<T> {
  T? get lastOrNull => isEmpty ? null : last;
}
