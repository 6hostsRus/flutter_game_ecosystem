// coverage:ignore-file
library services.monetization.gateway_port;

import 'dart:async';

/// SKU type.
enum SkuType { consumable, nonConsumable, subscription }

/// Purchase state.
enum PurchaseState { pending, success, cancelled, failed }

/// Price details.
class Price {
  final int amountMicros;        // 4990000 = $4.99
  final String currencyCode;     // e.g., 'USD'
  final String display;          // e.g., '$4.99'
  const Price({required this.amountMicros, required this.currencyCode, required this.display});
}

/// Product definition.
class Sku {
  final String id;
  final String title;
  final String description;
  final Price price;
  final SkuType type;
  final List<String> tags; // e.g., ['starter', 'holiday']
  const Sku({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    this.tags = const [],
  });
}

/// Availability info for a SKU in the current context (platform, region, flags).
class Availability {
  final String skuId;
  final bool available;
  final String? reason; // e.g., 'unsupported_platform', 'owned', 'region_blocked'
  const Availability(this.skuId, this.available, {this.reason});
}

/// Request to purchase a SKU.
class CheckoutRequest {
  final String skuId;
  final int quantity; // used for consumables. For non-consumables/subs, must be 1.
  final Map<String, Object?> payload; // custom metadata (e.g., campaign/offerId)
  const CheckoutRequest({required this.skuId, this.quantity = 1, this.payload = const {}});
}

/// Purchase result.
class PurchaseResult {
  final PurchaseState state;
  final String skuId;
  final String? orderId;
  final String? errorCode;
  final String? errorMessage;
  const PurchaseResult({
    required this.state,
    required this.skuId,
    this.orderId,
    this.errorCode,
    this.errorMessage,
  });
}

/// Receipt (opaque container to caller; adapters can extend via payload).
class PurchaseReceipt {
  final String transactionId;
  final String skuId;
  final DateTime purchaseTime;
  final Map<String, Object?> payload;
  const PurchaseReceipt({
    required this.transactionId,
    required this.skuId,
    required this.purchaseTime,
    this.payload = const {},
  });
}

/// Monetization gateway "port" (interface) independent of platform.
abstract class MonetizationGatewayPort {
  /// List SKUs (optionally filter by tag).
  Future<List<Sku>> listSkus({String? tag});

  /// Is the SKU available for this user/context?
  Future<Availability> availability(String skuId, {Map<String, Object?> context = const {}});

  /// Start a purchase flow.
  Future<PurchaseResult> checkout(CheckoutRequest req);

  /// Restore previously owned purchases (non-consumables/subscriptions).
  Future<List<PurchaseReceipt>> restorePurchases();

  /// Stream of purchase results (including those started outside the app restore flows).
  Stream<PurchaseResult> get purchaseStream;
}
