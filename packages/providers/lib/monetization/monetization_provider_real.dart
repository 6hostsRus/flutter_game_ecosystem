library providers.monetization.monetization_provider_real;

import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:services/monetization/gateway_port.dart';
import 'package:services/monetization/mock_dev_adapter.dart';
import 'package:services/monetization/in_app_purchase_adapter.dart';

/// Provide your SKU set here (play/app store product ids).
final skuIdsProvider = Provider<Set<String>>((ref) => {
      // Example IDs — replace with your real product IDs configured in stores:
      'pack.starter.001',
      'pack.winter.2025',
      'sub.premium.monthly',
    });

/// Feature flag to choose adapter (override in your app bootstrap).
final useRealStoreProvider = Provider<bool>((ref) => false);

final monetizationGatewayProvider = Provider<MonetizationGatewayPort>((ref) {
  final useReal = ref.watch(useRealStoreProvider);
  if (useReal && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS)) {
    final adapter = InAppPurchaseMonetizationAdapter(ref.read(skuIdsProvider));
    // We can't await in Provider constructor; you can call init() from your app init.
    // ignore: invalid_use_of_visible_for_testing_member
    adapter.init();
    return adapter;
  }
  // Fallback to mock adapter for dev, web, or unsupported platforms.
  return MockDevMonetizationAdapter([
    Sku(
      id: 'pack.starter.001',
      title: 'Starter Pack',
      description: 'Small boost to get you going.',
      price:
          Price(amountMicros: 1990000, currencyCode: 'USD', display: '\$1.99'),
      type: SkuType.consumable,
      tags: ['starter'],
    ),
    Sku(
      id: 'pack.winter.2025',
      title: 'Winter 2025 Bundle',
      description: 'Seasonal cosmetics.',
      price:
          Price(amountMicros: 4990000, currencyCode: 'USD', display: '\$4.99'),
      type: SkuType.nonConsumable,
      tags: ['holiday'],
    ),
    Sku(
      id: 'sub.premium.monthly',
      title: 'Premium Monthly',
      description: 'Ad-free + bonus rewards.',
      price:
          Price(amountMicros: 9990000, currencyCode: 'USD', display: '\$9.99'),
      type: SkuType.subscription,
      tags: ['premium'],
    ),
  ]);
});
