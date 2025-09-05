import 'package:flutter_test/flutter_test.dart';
import 'package:services/monetization/in_app_purchase_adapter.dart';
import 'package:services/monetization/gateway_port.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() {
  group('InAppPurchaseMonetizationAdapter mapping', () {
    test('maps PurchaseStatus variants to PurchaseState', () async {
      final iap = InAppPurchase.instance;
      // Seed catalog with a product.
      iap.seedProducts([
        ProductDetails(
          id: 'sku.test',
          title: 'Test Product',
          description: 'Desc',
          price: const ProductPrice(price: '', raw: '5000000'),
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

      expect(received.map((e) => e.state).toSet(), {
        PurchaseState.pending,
        PurchaseState.success,
        PurchaseState.cancelled,
        PurchaseState.failed,
      });
      // Ensure success appears at least once.
      expect(received.any((r) => r.isSuccess), true);
    });

    test('unavailable store yields failed checkout and empty list', () async {
      final iap = InAppPurchase.instance;
      iap.setAvailable(false);
      final adapter =
          InAppPurchaseMonetizationAdapter({'sku.missing'}, iap: iap);
      await adapter.init();
      final skus = await adapter.listSkus();
      expect(skus, isEmpty);
      final res =
          await adapter.checkout(const CheckoutRequest(skuId: 'sku.missing'));
      expect(res.state, PurchaseState.failed);
      expect(res.errorCode, 'store_unavailable');
      iap.setAvailable(true); // reset
    });

    test('unknown sku checkout fails fast', () async {
      final iap = InAppPurchase.instance;
      iap.seedProducts([]); // ensure empty
      final adapter = InAppPurchaseMonetizationAdapter({'sku.ghost'}, iap: iap);
      await adapter.init();
      final res =
          await adapter.checkout(const CheckoutRequest(skuId: 'sku.ghost'));
      expect(res.state, PurchaseState.failed);
      expect(res.errorCode, 'unknown_sku');
    });

    test('restore emits success events for restored purchases', () async {
      final iap = InAppPurchase.instance;
      iap.seedProducts([
        ProductDetails(
          id: 'sku.sub',
          title: 'Sub',
          description: 'Sub desc',
          price: const ProductPrice(price: '\$3.99', raw: '3990000'),
          currencyCode: 'USD',
        ),
      ]);
      final adapter = InAppPurchaseMonetizationAdapter({'sku.sub'}, iap: iap);
      await adapter.init();
      final events = <PurchaseResult>[];
      final sub = adapter.purchaseStream.listen(events.add);
      // Emit restored manually
      iap.debugEmitStatus('sku.sub', PurchaseStatus.restored);
      await Future.delayed(const Duration(milliseconds: 5));
      expect(events.any((e) => e.state == PurchaseState.success), true);
      await sub.cancel();
    });
  });
}
