// change-class: feature
// Factory for selecting monetization gateway implementation.
// Uses a compile-time environment flag `USE_REAL_IAP` (default false) to
// determine whether to use the real store plugin implementation (future) or
// the current in_app_purchase adapter backed by a local stub.

import 'gateway_port.dart';
import 'in_app_purchase_adapter.dart';

const bool _useRealIap =
    bool.fromEnvironment('USE_REAL_IAP', defaultValue: false);

MonetizationGatewayPort createMonetizationGateway(Set<String> skuIds) {
  // TODO(real-iap): When integrating the genuine `in_app_purchase` plugin,
  // branch here to return a production adapter variant.
  // For now we always return the existing adapter; flag reserved for future.
  if (_useRealIap) {
    // Placeholder: would construct real plugin-backed adapter variant.
    return InAppPurchaseMonetizationAdapter(skuIds);
  }
  return InAppPurchaseMonetizationAdapter(skuIds);
}
