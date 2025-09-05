library in_app_purchase;

// Local stub of `in_app_purchase` plugin.
// Upstream reference version: 3.2.x (subset only).
// TODO(parity:2025-09-30): Re-verify symbols & adapt to any upstream API changes.

import 'dart:async';

/// Enum mirroring real plugin's PurchaseStatus.
enum PurchaseStatus { pending, purchased, error, canceled, restored }

/// Basic error container.
class IAPError {
  final String code;
  final String message;
  IAPError(this.code, this.message);
}

/// Verification data placeholder.
class PurchaseVerificationData {
  final String localVerificationData;
  final String serverVerificationData;
  final String source;
  PurchaseVerificationData({
    required this.localVerificationData,
    required this.serverVerificationData,
    required this.source,
  });
}

/// Purchase details placeholder.
class PurchaseDetails {
  final String productID;
  final String? purchaseID;
  final PurchaseStatus status;
  final IAPError? error;
  final bool pendingCompletePurchase;
  final PurchaseVerificationData verificationData;
  PurchaseDetails({
    required this.productID,
    this.purchaseID,
    required this.status,
    this.error,
    this.pendingCompletePurchase = false,
    PurchaseVerificationData? verificationData,
  }) : verificationData = verificationData ??
            PurchaseVerificationData(
              localVerificationData: '',
              serverVerificationData: purchaseID ?? '',
              source: 'stub',
            );
}

/// Product price wrapper similar to real plugin (we only need display + raw string for micros parse attempt).
class ProductPrice {
  final String price;
  final String? raw;
  const ProductPrice({required this.price, this.raw});
  @override
  String toString() => price;
}

/// Base product details.
class ProductDetails {
  final String id;
  final String title;
  final String description;
  final ProductPrice price;
  final String? currencyCode;
  ProductDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.currencyCode,
  });

  @override
  String toString() =>
      'ProductDetails(id: ' + id + ', price: ' + price.toString() + ')';
}

/// Subscription subclass marker (matches `is SubscriptionProductDetails` checks).
class SubscriptionProductDetails extends ProductDetails {
  SubscriptionProductDetails({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    super.currencyCode,
  });
}

/// Query response object.
class ProductDetailsResponse {
  final List<ProductDetails> productDetails;
  final List<String> notFoundIDs;
  ProductDetailsResponse({
    required this.productDetails,
    required this.notFoundIDs,
  });
}

/// PurchaseParam placeholder.
class PurchaseParam {
  final ProductDetails productDetails;
  PurchaseParam({required this.productDetails});
}

/// Main entry point (singleton in real plugin).
class InAppPurchase {
  static final InAppPurchase instance = InAppPurchase._();
  InAppPurchase._();

  final _purchaseCtrl = StreamController<List<PurchaseDetails>>.broadcast();
  Stream<List<PurchaseDetails>> get purchaseStream => _purchaseCtrl.stream;

  // In-memory registered products (acting as a fake catalog).
  final Map<String, ProductDetails> _catalog = {};
  final Set<String> _owned = <String>{};
  bool _autoComplete = true;

  bool _available = true;

  /// Test helper to seed products.
  void seedProducts(Iterable<ProductDetails> products) {
    for (final p in products) {
      _catalog[p.id] = p;
    }
  }

  /// Reset internal state (catalog, ownership, availability, auto-complete).
  void reset() {
    _catalog.clear();
    _owned.clear();
    _available = true;
    _autoComplete = true;
  }

  /// Control whether buy* calls automatically emit a purchase success.
  void setAutoComplete(bool v) => _autoComplete = v;

  /// Simulate store availability toggle.
  void setAvailable(bool v) => _available = v;

  Future<bool> isAvailable() async => _available;

  Future<ProductDetailsResponse> queryProductDetails(Set<String> ids) async {
    final found = <ProductDetails>[];
    final notFound = <String>[];
    for (final id in ids) {
      final p = _catalog[id];
      if (p != null) {
        found.add(p);
      } else {
        notFound.add(id);
      }
    }
    return ProductDetailsResponse(productDetails: found, notFoundIDs: notFound);
  }

  Future<void> buyConsumable({
    required PurchaseParam purchaseParam,
    required bool autoConsume,
  }) async {
    if (_autoComplete) {
      _emitSuccess(purchaseParam.productDetails.id);
    } else {
      // Emit a pending status to simulate in-flight purchase.
      debugEmitStatus(purchaseParam.productDetails.id, PurchaseStatus.pending,
          pendingCompletePurchase: true);
    }
  }

  Future<void> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    if (_autoComplete) {
      _emitSuccess(purchaseParam.productDetails.id);
    } else {
      debugEmitStatus(purchaseParam.productDetails.id, PurchaseStatus.pending,
          pendingCompletePurchase: true);
    }
  }

  Future<void> completePurchase(PurchaseDetails details) async {}

  Future<void> restorePurchases() async {
    if (_owned.isEmpty) return;
    // Emit restored events for each owned product.
    final events = <PurchaseDetails>[];
    for (final id in _owned) {
      events.add(PurchaseDetails(
        productID: id,
        purchaseID: 'restore_$id',
        status: PurchaseStatus.restored,
        pendingCompletePurchase: false,
        verificationData: PurchaseVerificationData(
          localVerificationData: 'restore_$id',
          serverVerificationData: 'restore_$id',
          source: 'restore',
        ),
      ));
    }
    _purchaseCtrl.add(events);
  }

  // Helper to emit a purchase success event.
  void _emitSuccess(String productId) {
    final details = PurchaseDetails(
      productID: productId,
      status: PurchaseStatus.purchased,
      purchaseID: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      pendingCompletePurchase: false,
    );
    _owned.add(productId);
    _purchaseCtrl.add([details]);
  }

  // --- Debug/Test Helpers ---
  /// Emit a custom list of [PurchaseDetails] objects onto the purchase stream.
  void debugEmit(List<PurchaseDetails> detailsList) {
    _purchaseCtrl.add(detailsList);
  }

  /// Convenience helper to emit a single purchase event with a given [status].
  void debugEmitStatus(
    String productId,
    PurchaseStatus status, {
    String? orderId,
    bool pendingCompletePurchase = false,
    IAPError? error,
    String? serverVerificationDataOverride,
  }) {
    final id = orderId ?? 'ord_${DateTime.now().millisecondsSinceEpoch}';
    final details = PurchaseDetails(
      productID: productId,
      purchaseID: id,
      status: status,
      error: error,
      pendingCompletePurchase: pendingCompletePurchase,
      verificationData: PurchaseVerificationData(
        localVerificationData: id,
        serverVerificationData: serverVerificationDataOverride ?? id,
        source: 'debug',
      ),
    );
    _purchaseCtrl.add([details]);
  }
}
