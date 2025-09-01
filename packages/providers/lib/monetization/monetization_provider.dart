library providers.monetization.monetization_provider;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:services/monetization/gateway_port.dart';
import 'package:services/monetization/mock_dev_adapter.dart';

/// Default SKUs used by the mock adapter.
final _defaultMockSkus = <Sku>[
  Sku(
    id: 'pack.starter.001',
    title: 'Starter Pack',
    description: 'Small boost to get you going.',
    price: Price(amountMicros: 1990000, currencyCode: 'USD', display: '\$1.99'),
    type: SkuType.consumable,
    tags: ['starter'],
  ),
  Sku(
    id: 'pack.winter.2025',
    title: 'Winter 2025 Bundle',
    description: 'Seasonal cosmetics.',
    price: Price(amountMicros: 4990000, currencyCode: 'USD', display: '\$4.99'),
    type: SkuType.nonConsumable,
    tags: ['holiday'],
  ),
  Sku(
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
  return MockDevMonetizationAdapter(_defaultMockSkus);
});
