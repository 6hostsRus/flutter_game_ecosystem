import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/monetization/monetization_provider_real.dart';
import 'package:services/monetization/gateway_port.dart';

/// Example app-level bootstrap to enable real store adapters.
Future<void> bootstrapMonetizationReal(WidgetRef ref) async {
  // Override to enable real store (only on Android/iOS/macOS).
  final container = ProviderContainer(overrides: [
    useRealStoreProvider.overrideWithValue(true),
    skuIdsProvider.overrideWithValue({
      'pack.starter.001',
      'pack.winter.2025',
      'sub.premium.monthly',
    }),
  ]);

  final gateway = container.read(monetizationGatewayProvider);

  // If using InAppPurchase adapter, call init once.
  if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
    try {
      // ignore: invalid_use_of_visible_for_testing_member
      (gateway as dynamic).init?.call();
    } catch (_) {}
  }

  // Optionally: prefetch catalog
  await gateway.listSkus();
}
