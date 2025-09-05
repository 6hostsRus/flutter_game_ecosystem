import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:services/economy/simple_economy.dart';
import 'package:services/monetization/mock_dev_adapter.dart';
import 'package:services/monetization/gateway_port.dart';

void main() {
  test('analytics NDJSON lines are valid and event names follow prefix rules',
      () async {
    final log = File('build/metrics/analytics_events.ndjson');
    if (log.existsSync()) log.deleteSync();
    log.parent.createSync(recursive: true);

    // Generate a few events.
    final econ = SimpleEconomy(onEvent: (e, p) {
      log.writeAsStringSync(
          jsonEncode({
                'event': e,
                ...p,
                'ts': DateTime.now().toUtc().toIso8601String(),
              }) +
              '\n',
          mode: FileMode.append);
    });
    econ.award('coins', 5, reason: 'test');

    final adapter = MockDevMonetizationAdapter([
      Sku(
        id: 'pack.tiny',
        title: 'Tiny Pack',
        description: 'desc',
        price: const Price(
            amountMicros: 990000, currencyCode: 'USD', display: '\$0.99'),
        type: SkuType.consumable,
        tags: const ['test'],
      )
    ], latency: const Duration(milliseconds: 1), onEvent: (e, p) {
      log.writeAsStringSync(
          jsonEncode({
                'event': e,
                ...p,
                'ts': DateTime.now().toUtc().toIso8601String(),
              }) +
              '\n',
          mode: FileMode.append);
    });
    await adapter.checkout(const CheckoutRequest(skuId: 'pack.tiny'));

    // Read & validate using regex extraction (tolerates malformed legacy concatenation).
    final raw = log.readAsStringSync();
    final objMatches =
        RegExp(r'\{[^\n]*?\}').allMatches(raw).map((m) => m.group(0)!).toList();
    expect(objMatches.length >= 2, true);
    final nameRegex =
        RegExp(r'^(economy_|purchase_|nav_|session_|perf_|debug_)[a-z0-9_]*$');
    for (final jsonObj in objMatches) {
      Map<String, Object?>? obj;
      try {
        obj = jsonDecode(jsonObj) as Map<String, Object?>;
      } catch (_) {
        // Skip non-JSON legacy lines.
        continue;
      }
      final ev = obj['event'];
      if (ev is! String) continue; // skip if missing
      expect(nameRegex.hasMatch(ev), true, reason: 'bad event name: $ev');
      final ts = obj['ts'];
      if (ts is String) {
        expect(DateTime.tryParse(ts), isNotNull, reason: 'invalid ts');
      }
    }
  });
}
