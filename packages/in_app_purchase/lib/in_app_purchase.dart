library in_app_purchase;

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
  }) : verificationData =
           verificationData ??
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

  bool _available = true;

  /// Test helper to seed products.
  void seedProducts(Iterable<ProductDetails> products) {
    for (final p in products) {
      _catalog[p.id] = p;
    }
  }

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
    _emitSuccess(purchaseParam.productDetails.id);
  }

  Future<void> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    _emitSuccess(purchaseParam.productDetails.id);
  }

  Future<void> completePurchase(PurchaseDetails details) async {}

  Future<void> restorePurchases() async {}

  // Helper to emit a purchase success event.
  void _emitSuccess(String productId) {
    final details = PurchaseDetails(
      productID: productId,
      status: PurchaseStatus.purchased,
      purchaseID: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      pendingCompletePurchase: false,
    );
    _purchaseCtrl.add([details]);
  }
}
