library providers.monetization.monetization_provider;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:services/monetization/gateway_port.dart';
import 'package:services/monetization/mock_dev_adapter.dart';
import 'package:services/monetization/in_app_purchase_adapter.dart';
import '../flags/real_plugin_matrix.dart';

/// Default SKUs used by the mock adapter.
final _defaultMockSkus = <Sku>[
  const Sku(
    id: 'pack.starter.001',
    title: 'Starter Pack',
    description: 'Small boost to get you going.',
    price: Price(amountMicros: 1990000, currencyCode: 'USD', display: '\$1.99'),
    type: SkuType.consumable,
    tags: ['starter'],
  ),
  const Sku(
    id: 'pack.winter.2025',
    title: 'Winter 2025 Bundle',
    description: 'Seasonal cosmetics.',
    price: Price(amountMicros: 4990000, currencyCode: 'USD', display: '\$4.99'),
    type: SkuType.nonConsumable,
    tags: ['holiday'],
  ),
  const Sku(
    id: 'sub.premium.monthly',
    title: 'Premium Monthly',
    description: 'Ad-free + bonus rewards.',
    price: Price(amountMicros: 9990000, currencyCode: 'USD', display: '\$9.99'),
    type: SkuType.subscription,
    tags: ['premium'],
  ),
];

/// Provider for the monetization gateway (mock by default).
final monetizationGatewayProvider = Provider<MonetizationGatewayPort>((ref) {
  // Default to mock adapter; upgrade to real if the matrix resolves to true.
  final fallback = MockDevMonetizationAdapter(_defaultMockSkus);
  final useRealAsync = ref.watch(useRealIapFromMatrixProvider);
  return useRealAsync.maybeWhen(
    data: (v) {
      if (v) {
        // In-app purchase adapter expects SKU set; use defaults here. Apps should override with their own SKUs.
        final ids = _defaultMockSkus.map((s) => s.id).toSet();
        final adapter = InAppPurchaseMonetizationAdapter(ids);
        // ignore: invalid_use_of_visible_for_testing_member
        adapter.init();
        return adapter;
      }
      return fallback;
    },
    orElse: () => fallback,
  );
});
