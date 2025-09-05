library providers.analytics.analytics_hooks;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:services/economy/simple_economy.dart';
import 'package:services/monetization/mock_dev_adapter.dart';
import 'package:providers/monetization/monetization_provider.dart';
import 'package:services/monetization/gateway_port.dart';
import 'package:services/analytics/analytics_port.dart';
import 'analytics_provider.dart';

/// Provide an instrumented SimpleEconomy instance.
final simpleEconomyProvider = Provider<SimpleEconomy>((ref) {
  final analytics = ref.watch(analyticsPortProvider);
  return SimpleEconomy(onEvent: (e, p) => analytics.send(AnalyticsEvent(e, p)));
});

/// Decorated monetization provider emitting analytics events (for mock adapter).
final analyticsMonetizationGatewayProvider =
    Provider<MonetizationGatewayPort>((ref) {
  final analytics = ref.watch(analyticsPortProvider);
  final base = ref.watch(monetizationGatewayProvider);
  if (base is MockDevMonetizationAdapter) {
    return AnalyticsMonetizationDecorator(base,
        onEvent: (e, p) => analytics.send(AnalyticsEvent(e, p)));
  }
  return base; // fallback if real adapter already emits events internally.
});
