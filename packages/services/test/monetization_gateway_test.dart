import 'package:flutter_test/flutter_test.dart';
import 'package:services/monetization/gateway_port.dart';
import 'package:services/monetization/mock_dev_adapter.dart';

void main() {
  final skus = <Sku>[
    Sku(
      id: 'consumable.coin100',
      title: '100 Coins',
      description: 'Consumable currency',
      price: Price(amountMicros: 1990000, currencyCode: 'USD', display: '\$1.99'),
      type: SkuType.consumable,
    ),
    Sku(
      id: 'entitlement.noads',
      title: 'No Ads',
      description: 'Remove ads forever',
      price: Price(amountMicros: 2990000, currencyCode: 'USD', display: '\$2.99'),
      type: SkuType.nonConsumable,
    ),
  ];

  test('list -> checkout -> restore', () async {
    final mock = MockDevMonetizationAdapter(skus, latency: Duration(milliseconds: 1));

    // list
    final list = await mock.listSkus();
    expect(list.length, 2);

    // purchase entitlement
    final res1 = await mock.checkout(CheckoutRequest(skuId: 'entitlement.noads'));
    expect(res1.state, PurchaseState.success);

    // re-purchase should fail
    final res2 = await mock.checkout(CheckoutRequest(skuId: 'entitlement.noads'));
    expect(res2.state, PurchaseState.failed);

    // restore should include entitlement
    final receipts = await mock.restorePurchases();
    expect(receipts.any((r) => r.skuId == 'entitlement.noads'), true);
  });
}
