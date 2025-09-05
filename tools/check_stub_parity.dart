// change-class: infra
// Stub Parity Check Script
// Ensures local stubs match expected critical symbols of upstream packages.
// Currently supports: in_app_purchase (TODO: add more as stubs appear)
// Usage: dart run tools/check_stub_parity.dart

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
  final path = 'packages/in_app_purchase/lib/in_app_purchase.dart';
  final file = File(path);
  if (!file.existsSync()) {
    failures.add('Missing in_app_purchase stub at $path');
    return;
  }
  final src = file.readAsStringSync();
  final requiredSymbols = [
    'class InAppPurchase',
    'class ProductDetails',
    'class PurchaseDetails',
    'enum PurchaseStatus',
    'class PurchaseParam',
  ];
  for (final sym in requiredSymbols) {
    if (!src.contains(sym)) {
      failures.add('in_app_purchase stub missing symbol: $sym');
    }
  }
  // Simple freshness heuristic: must contain a TODO parity tag with a date.
  if (!RegExp(r'TODO\(parity:').hasMatch(src)) {
    failures.add(
      'Missing parity TODO tag with date in in_app_purchase stub header',
    );
  }
}
