// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart' as iap;
import 'package:services/monetization/gateway_port.dart';
import 'package:services/monetization/in_app_purchase_adapter.dart';

// Top-level helper to capture the next event.
Future<PurchaseResult> _nextEvent(
    InAppPurchaseMonetizationAdapter adapter) async {
  final completer = Completer<PurchaseResult>();
  late StreamSubscription sub;
  sub = adapter.purchaseStream.listen((e) {
    completer.complete(e);
    sub.cancel();
  });
  return completer.future;
}

void main() {
  group('InAppPurchaseMonetizationAdapter', () {
    late InAppPurchaseMonetizationAdapter adapter;
    const sku = 'coins.small';
    const sku2 = 'premium.remove_ads';

    Future<iap.ProductDetails> seedProduct({
      required String id,
      String title = 'Coins Small',
      String description = '100 coins pack',
      String displayPrice = '\$0.99',
      String rawMicros = '990000',
      String currency = 'USD',
      bool subscription = false,
    }) async {
      final price = iap.ProductPrice(price: displayPrice, raw: rawMicros);
      final p = subscription
          ? iap.SubscriptionProductDetails(
              id: id,
              title: title,
              description: description,
              price: price,
              currencyCode: currency,
            )
          : iap.ProductDetails(
              id: id,
              title: title,
              description: description,
              price: price,
              currencyCode: currency,
            );
      iap.InAppPurchase.instance.seedProducts([p]);
      return p;
    }

    setUp(() async {
      iap.InAppPurchase.instance.reset();
      await seedProduct(id: sku, displayPrice: '\$0.99', rawMicros: '990000');
      await seedProduct(
        id: sku2,
        title: 'Remove Ads',
        description: 'Premium',
        displayPrice: '\$4.99',
        rawMicros: '4990000',
      );
      adapter = InAppPurchaseMonetizationAdapter({sku, sku2});
      await adapter.init();
    });

    tearDown(() {
      adapter.dispose();
      iap.InAppPurchase.instance.reset();
    });

    test('listSkus maps product details correctly', () async {
      final skus = await adapter.listSkus();
      expect(skus.length, 2);
      final s = skus.firstWhere((e) => e.id == sku);
      expect(s.title, 'Coins Small');
      expect(s.price.amountMicros, 990000);
      expect(s.price.currencyCode, 'USD');
      expect(s.price.display.contains('0.99'), true);
      expect(s.type, SkuType.consumable);
    });

    test('availability returns true for known SKU, false for unknown',
        () async {
      final ok = await adapter.availability(sku);
      expect(ok.isAvailable, true);
      final bad = await adapter.availability('missing.sku');
      expect(bad.isAvailable, false);
      expect(bad.reason, 'unknown_sku');
    });

    test('checkout success flow emits success on stream', () async {
      iap.InAppPurchase.instance.setAvailable(true);
      final eventFut = _nextEvent(adapter);
      final r = await adapter.checkout(CheckoutRequest(skuId: sku));
      expect(r.state, PurchaseState.pending);
      final e = await eventFut;
      expect(e.skuId, sku);
      expect(e.state, PurchaseState.success);
      expect(e.orderId?.isNotEmpty, true);
    });

    test('pending then purchased sequence', () async {
      iap.InAppPurchase.instance.setAutoComplete(false);
      adapter.purchaseTimeout = const Duration(seconds: 2);
      final firstEvt = _nextEvent(adapter);
      final r = await adapter.checkout(CheckoutRequest(skuId: sku));
      expect(r.isPending, true);
      final pending = await firstEvt;
      expect(pending.state, PurchaseState.pending);

      final successEvt = _nextEvent(adapter);
      iap.InAppPurchase.instance
          .debugEmitStatus(sku, iap.PurchaseStatus.purchased);
      final success = await successEvt;
      expect(success.state, PurchaseState.success);
    });

    test('user cancelled purchase maps to cancelled state', () async {
      final evt = _nextEvent(adapter);
      iap.InAppPurchase.instance
          .debugEmitStatus(sku, iap.PurchaseStatus.canceled);
      final r = await evt;
      expect(r.state, PurchaseState.cancelled);
      expect(r.skuId, sku);
    });

    test('error purchase maps to failed with error code', () async {
      final evt = _nextEvent(adapter);
      iap.InAppPurchase.instance.debugEmitStatus(
        sku,
        iap.PurchaseStatus.error,
        error: iap.IAPError('E_FAIL', 'Boom'),
      );
      final r = await evt;
      expect(r.state, PurchaseState.failed);
      expect(r.errorCode, 'E_FAIL');
    });

    test('restorePurchases emits restored (mapped to success)', () async {
      final evt1 = _nextEvent(adapter);
      await adapter.checkout(CheckoutRequest(skuId: sku));
      await evt1; // success

      final restoredEvt = _nextEvent(adapter);
      await adapter.restorePurchases();
      final r = await restoredEvt;
      expect(r.skuId, sku);
      expect(r.state, PurchaseState.success);
      expect(r.orderId?.startsWith('restore_') ?? true, true);
    });

    test(
        'store unavailable: listSkus empty, availability false, checkout fails',
        () async {
      iap.InAppPurchase.instance.setAvailable(false);
      final skus = await adapter.listSkus();
      expect(skus, isEmpty);
      final a = await adapter.availability(sku);
      expect(a.isAvailable, false);
      expect(a.reason, 'store_unavailable');
      final evt = _nextEvent(adapter);
      final res = await adapter.checkout(CheckoutRequest(skuId: sku));
      expect(res.state, PurchaseState.failed);
      expect(res.errorCode, 'store_unavailable');
      final emitted = await evt;
      expect(emitted.state, PurchaseState.failed);
      expect(emitted.errorCode, 'store_unavailable');
    });

    test('unknown sku checkout fails fast', () async {
      final res =
          await adapter.checkout(const CheckoutRequest(skuId: 'sku.ghost'));
      expect(res.state, PurchaseState.failed);
      expect(res.errorCode, 'unknown_sku');
    });

    test('verification failure maps purchased -> failed', () async {
      adapter.verify = (_) => false;
      final evt = _nextEvent(adapter);
      iap.InAppPurchase.instance
          .debugEmitStatus(sku, iap.PurchaseStatus.purchased);
      final r = await evt;
      expect(r.state, PurchaseState.failed);
    });

    test('timeout emits failed result when no completion arrives', () async {
      await seedProduct(
        id: 'sku.slow',
        title: 'Slow',
        displayPrice: '\$2.00',
        rawMicros: '2000000',
      );
      iap.InAppPurchase.instance.setAutoComplete(false);
      final slowAdapter = InAppPurchaseMonetizationAdapter({'sku.slow'})
        ..purchaseTimeout = const Duration(milliseconds: 60);
      await slowAdapter.init();
      final events = <PurchaseResult>[];
      final sub = slowAdapter.purchaseStream.listen(events.add);
      await slowAdapter.checkout(const CheckoutRequest(skuId: 'sku.slow'));
      await Future.delayed(const Duration(milliseconds: 120));
      expect(events.any((e) => e.errorCode == 'timeout'), true);
      await sub.cancel();
      slowAdapter.dispose();
      iap.InAppPurchase.instance.setAutoComplete(true);
    });
  });
}
