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
  });
}
