// coverage:ignore-file
library services.monetization.adapters.in_app_purchase_adapter;

import 'dart:async';
import 'dart:io' show Platform;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'gateway_port.dart';

/// Adapter backed by the official `in_app_purchase` plugin.
/// Works for Google Play Billing (Android) and StoreKit (iOS/macOS).
class InAppPurchaseMonetizationAdapter implements MonetizationGatewayPort {
  final InAppPurchase _iap;
  final Set<String> _skuIds;
  final _ctrl = StreamController<PurchaseResult>.broadcast();
  late final StreamSubscription<List<PurchaseDetails>> _sub;
  bool _initialized = false;

  InAppPurchaseMonetizationAdapter(this._skuIds, {InAppPurchase? iap})
      : _iap = iap ?? InAppPurchase.instance;

  /// Must be called once before using other APIs.
  Future<void> init() async {
    if (_initialized) return;
    // Listen to purchase updates.
    _sub = _iap.purchaseStream
        .listen(_onPurchaseUpdates, onDone: () => _ctrl.close());
    _initialized = true;
  }

  void _onPurchaseUpdates(List<PurchaseDetails> detailsList) {
    for (final d in detailsList) {
      PurchaseState state;
      switch (d.status) {
        case PurchaseStatus.purchased:
          state = PurchaseState.success;
          break;
        case PurchaseStatus.pending:
          state = PurchaseState.pending;
          break;
        case PurchaseStatus.restored:
          state = PurchaseState.success;
          break;
        case PurchaseStatus.canceled:
          state = PurchaseState.cancelled;
          break;
        case PurchaseStatus.error:
          state = PurchaseState.failed;
          break;
      }

      final result = PurchaseResult(
        state: state,
        skuId: d.productID,
        orderId: d.verificationData.serverVerificationData.isNotEmpty
            ? d.verificationData.serverVerificationData
            : d.purchaseID ?? d.productID,
        errorCode: d.error?.code,
        errorMessage: d.error?.message,
      );
      _ctrl.add(result);

      // For successful purchases, you must complete the purchase.
      if (d.pendingCompletePurchase) {
        _iap.completePurchase(d);
      }
    }
  }

  @override
  Stream<PurchaseResult> get purchaseStream => _ctrl.stream;

  @override
  Future<List<Sku>> listSkus({String? tag}) async {
    final ok = await _iap.isAvailable();
    if (!ok) return [];
    final response = await _iap.queryProductDetails(_skuIds);
    final products = response.productDetails;
    return products.map(_mapProduct).toList();
  }

  Sku _mapProduct(ProductDetails p) {
    final micros = int.tryParse(p.price.raw ?? '') ?? 0;
    return Sku(
      id: p.id,
      title: p.title,
      description: p.description,
      price: Price(
          amountMicros: micros,
          currencyCode: p.currencyCode ?? 'USD',
          display: p.price),
      type: _guessType(p),
      tags: const [],
    );
  }

  SkuType _guessType(ProductDetails p) {
    // `in_app_purchase` exposes type-specific classes in newer versions;
    // fallback heuristic: subscriptions often include words; adjust as needed.
    final t = (p is SubscriptionProductDetails) ? 'subscription' : 'inapp';
    if (t == 'subscription') return SkuType.subscription;
    // Non-consumable vs consumable is determined by how you consume/acknowledge.
    // Default to consumable (safer for currency). Override in your app if needed.
    return SkuType.consumable;
  }

  @override
  Future<Availability> availability(String skuId,
      {Map<String, Object?> context = const {}}) async {
    final ok = await _iap.isAvailable();
    if (!ok) return Availability(skuId, false, reason: 'store_unavailable');
    final response = await _iap.queryProductDetails({skuId});
    if (response.notFoundIDs.contains(skuId)) {
      return Availability(skuId, false, reason: 'unknown_sku');
    }
    return Availability(skuId, true);
  }

  @override
  Future<PurchaseResult> checkout(CheckoutRequest req) async {
    final ok = await _iap.isAvailable();
    if (!ok) {
      final r = PurchaseResult(
          state: PurchaseState.failed,
          skuId: req.skuId,
          errorCode: 'store_unavailable');
      _ctrl.add(r);
      return r;
    }
    final response = await _iap.queryProductDetails({req.skuId});
    if (response.notFoundIDs.contains(req.skuId) ||
        response.productDetails.isEmpty) {
      final r = PurchaseResult(
          state: PurchaseState.failed,
          skuId: req.skuId,
          errorCode: 'unknown_sku');
      _ctrl.add(r);
      return r;
    }
    final product = response.productDetails.first;

    final param = PurchaseParam(productDetails: product);
    // For subscriptions, use buyNonConsumable/buyConsumable accordingly.
    if (product is SubscriptionProductDetails) {
      await _iap.buyNonConsumable(purchaseParam: param);
    } else {
      // Default to consumable; adjust based on your catalog metadata.
      await _iap.buyConsumable(purchaseParam: param, autoConsume: true);
    }

    // The actual result will arrive via purchaseStream listener.
    return PurchaseResult(state: PurchaseState.pending, skuId: req.skuId);
  }

  @override
  Future<List<PurchaseReceipt>> restorePurchases() async {
    await _iap.restorePurchases();
    // Receipts are surfaced as purchaseStream events with status.restored.
    // We don't have them synchronously; return empty and rely on stream.
    return const [];
  }

  void dispose() {
    _sub.cancel();
    _ctrl.close();
  }
}
