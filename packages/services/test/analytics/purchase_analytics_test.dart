import 'dart:io';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:services/monetization/gateway_port.dart';
import 'package:services/monetization/mock_dev_adapter.dart';

void main() {
  test('MockDevMonetizationAdapter emits analytics events', () async {
    final events = <Map<String, Object?>>[];
    final skus = [
      const Sku(
        id: 'pack.small',
        title: 'Small Pack',
        description: 'Test',
        price: Price(
            amountMicros: 1990000, currencyCode: 'USD', display: '\$1.99'),
        type: SkuType.consumable,
        tags: const ['test'],
      ),
    ];
    final adapter = MockDevMonetizationAdapter(
      skus,
      latency: const Duration(milliseconds: 1),
      onEvent: (e, p) {
        final record = {
          'event': e,
          ...p,
          'ts': DateTime.now().toUtc().toIso8601String(),
        };
        events.add(record);
        final log = File('build/metrics/analytics_events.ndjson');
        log.parent.createSync(recursive: true);
        log.writeAsStringSync(jsonEncode(record) + '\n', mode: FileMode.append);
      },
    );

    final r =
        await adapter.checkout(const CheckoutRequest(skuId: 'pack.small'));
    expect(r.state, PurchaseState.success);
    expect(events.where((e) => e['event'] == 'purchase_success').length, 1);

    final r2 = await adapter.checkout(const CheckoutRequest(skuId: 'unknown'));
    expect(r2.state, PurchaseState.failed);
    expect(
        events.where((e) => e['event'] == 'purchase_failed').isNotEmpty, true);
  });
}
