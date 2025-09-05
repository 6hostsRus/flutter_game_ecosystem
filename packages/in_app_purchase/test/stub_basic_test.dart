import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() {
  test('seed and query product', () async {
    final iap = InAppPurchase.instance;
    iap.seedProducts([
      ProductDetails(
        id: 'coins_100',
        title: '100 Coins',
        description: 'Pack',
        price: const ProductPrice(price: '\$0.99'),
      )
    ]);
    final resp = await iap.queryProductDetails({'coins_100'});
    expect(resp.productDetails.single.id, 'coins_100');
  });

  test('debugEmitStatus emits purchase', () async {
    final iap = InAppPurchase.instance;
    final events = <List<PurchaseDetails>>[];
    final sub = iap.purchaseStream.listen(events.add);
    iap.debugEmitStatus('coins_100', PurchaseStatus.purchased, orderId: 'o1');
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(events, isNotEmpty);
    await sub.cancel();
  });
}
