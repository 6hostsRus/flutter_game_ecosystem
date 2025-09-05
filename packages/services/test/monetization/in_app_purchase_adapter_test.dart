import 'package:flutter_test/flutter_test.dart';
import 'package:services/monetization/in_app_purchase_adapter.dart';
import 'package:services/monetization/gateway_port.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() {
  group('InAppPurchaseMonetizationAdapter', () {
    late InAppPurchase iap;
    setUp(() {
      iap = InAppPurchase.instance;
      iap.reset();
    });

    test('maps PurchaseStatus variants to PurchaseState', () async {
      iap.seedProducts([
        ProductDetails(
          id: 'sku.test',
          title: 'Test Product',
          description: 'Desc',
          price: const ProductPrice(price: '\$5.00', raw: '5000000'),
          currencyCode: 'USD',
        ),
      ]);
      final adapter = InAppPurchaseMonetizationAdapter({'sku.test'}, iap: iap);
      await adapter.init();
      final received = <PurchaseResult>[];
      final sub = adapter.purchaseStream.listen(received.add);
      iap.debugEmitStatus('sku.test', PurchaseStatus.pending);
      iap.debugEmitStatus('sku.test', PurchaseStatus.purchased);
      iap.debugEmitStatus('sku.test', PurchaseStatus.canceled);
      iap.debugEmitStatus('sku.test', PurchaseStatus.error,
          error: IAPError('x', 'fail'));
      iap.debugEmitStatus('sku.test', PurchaseStatus.restored);
      await Future.delayed(const Duration(milliseconds: 10));
      await sub.cancel();
      expect(
          received.map((e) => e.state).toSet(),
          containsAll({
            PurchaseState.pending,
            PurchaseState.success,
            PurchaseState.cancelled,
            PurchaseState.failed,
          }));
      expect(received.any((r) => r.isSuccess), true);
    });

    test('unavailable store yields failed checkout and empty list', () async {
      iap.setAvailable(false);
      final adapter =
          InAppPurchaseMonetizationAdapter({'sku.missing'}, iap: iap);
      await adapter.init();
      expect(await adapter.listSkus(), isEmpty);
      final res =
          await adapter.checkout(const CheckoutRequest(skuId: 'sku.missing'));
      expect(res.state, PurchaseState.failed);
      expect(res.errorCode, 'store_unavailable');
      iap.setAvailable(true);
    });

    test('unknown sku checkout fails fast', () async {
      iap.seedProducts([]);
      final adapter = InAppPurchaseMonetizationAdapter({'sku.ghost'}, iap: iap);
      await adapter.init();
      final res =
          await adapter.checkout(const CheckoutRequest(skuId: 'sku.ghost'));
      expect(res.state, PurchaseState.failed);
      expect(res.errorCode, 'unknown_sku');
    });

    test('verification failure maps purchased -> failed', () async {
      iap.seedProducts([
        ProductDetails(
          id: 'sku.secure',
          title: 'Secure',
          description: 'Secure desc',
          price: const ProductPrice(price: '\$1.00', raw: '1000000'),
          currencyCode: 'USD',
        ),
      ]);
      final adapter = InAppPurchaseMonetizationAdapter({'sku.secure'}, iap: iap)
        ..verify = (d) => false;
      await adapter.init();
      final events = <PurchaseResult>[];
      final sub = adapter.purchaseStream.listen(events.add);
      await adapter.checkout(const CheckoutRequest(skuId: 'sku.secure'));
      await Future.delayed(const Duration(milliseconds: 20));
      expect(events.any((e) => e.state == PurchaseState.failed), true);
      await sub.cancel();
    });

    test('timeout emits failed result when no completion arrives', () async {
      iap.seedProducts([
        ProductDetails(
          id: 'sku.slow',
          title: 'Slow',
          description: 'Slow desc',
          price: const ProductPrice(price: '\$2.00', raw: '2000000'),
          currencyCode: 'USD',
        ),
      ]);
      iap.setAutoComplete(false);
      final adapter = InAppPurchaseMonetizationAdapter({'sku.slow'}, iap: iap)
        ..purchaseTimeout = const Duration(milliseconds: 40);
      await adapter.init();
      final events = <PurchaseResult>[];
      final sub = adapter.purchaseStream.listen(events.add);
      await adapter.checkout(const CheckoutRequest(skuId: 'sku.slow'));
      await Future.delayed(const Duration(milliseconds: 100));
      expect(events.any((e) => e.errorCode == 'timeout'), true);
      await sub.cancel();
      iap.setAutoComplete(true);
    });

    test('restorePurchases emits additional success events for owned skus',
        () async {
      iap.seedProducts([
        ProductDetails(
          id: 'sku.restore',
          title: 'Restore',
          description: 'Restore desc',
          price: const ProductPrice(price: '\$4.00', raw: '4000000'),
          currencyCode: 'USD',
        ),
      ]);
      final adapter =
          InAppPurchaseMonetizationAdapter({'sku.restore'}, iap: iap);
      await adapter.init();
      final events = <PurchaseResult>[];
      final sub = adapter.purchaseStream.listen(events.add);
      // Perform purchase
      await adapter.checkout(const CheckoutRequest(skuId: 'sku.restore'));
      await Future.delayed(const Duration(milliseconds: 20));
      final before =
          events.where((e) => e.state == PurchaseState.success).length;
      await adapter.restorePurchases();
      await Future.delayed(const Duration(milliseconds: 20));
      final after =
          events.where((e) => e.state == PurchaseState.success).length;
      expect(after > before, true);
      await sub.cancel();
    });
  });
}
