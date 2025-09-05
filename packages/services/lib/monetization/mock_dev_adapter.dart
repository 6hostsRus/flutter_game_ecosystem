// coverage:ignore-file
library services.monetization.mock_dev_adapter;

import 'dart:async';
import 'dart:math';
import 'gateway_port.dart';

/// A development adapter that simulates a store.
class MockDevMonetizationAdapter implements MonetizationGatewayPort {
  final Map<String, Sku> _skus;
  final Set<String> _ownedNonConsumables = <String>{};
  final _rand = Random();
  final _ctrl = StreamController<PurchaseResult>.broadcast();

  /// Optional failure injection per SKU id.
  final Map<String, String> failureCodes; // skuId -> errorCode
  final Duration latency;

  /// Optional analytics hook invoked with (eventName, properties).
  final void Function(String event, Map<String, Object?> props)? onEvent;

  MockDevMonetizationAdapter(
    List<Sku> skus, {
    this.failureCodes = const {},
    this.latency = const Duration(milliseconds: 200),
    this.onEvent,
  }) : _skus = {for (final s in skus) s.id: s};

  @override
  Stream<PurchaseResult> get purchaseStream => _ctrl.stream;

  @override
  Future<List<Sku>> listSkus({String? tag}) async {
    await Future<void>.delayed(latency);
    final list =
        _skus.values.where((s) => tag == null || s.tags.contains(tag)).toList();
    list.sort((a, b) => a.price.amountMicros.compareTo(b.price.amountMicros));
    return list;
  }

  @override
  Future<Availability> availability(String skuId,
      {Map<String, Object?> context = const {}}) async {
    await Future<void>.delayed(latency);
    final sku = _skus[skuId];
    if (sku == null) return Availability(skuId, false, reason: 'unknown_sku');
    if (sku.type == SkuType.nonConsumable &&
        _ownedNonConsumables.contains(skuId)) {
      return Availability(skuId, false, reason: 'owned');
    }
    return Availability(skuId, true);
  }

  @override
  Future<PurchaseResult> checkout(CheckoutRequest req) async {
    await Future<void>.delayed(latency);
    final sku = _skus[req.skuId];
    if (sku == null) {
      final r = PurchaseResult(
          state: PurchaseState.failed,
          skuId: req.skuId,
          errorCode: 'unknown_sku',
          errorMessage: 'SKU not found');
      _ctrl.add(r);
      onEvent?.call(
          'purchase_failed', {'sku': req.skuId, 'reason': 'unknown_sku'});
      return r;
    }
    // Non-consumable guard
    if (sku.type == SkuType.nonConsumable &&
        _ownedNonConsumables.contains(sku.id)) {
      final r = PurchaseResult(
          state: PurchaseState.failed,
          skuId: sku.id,
          errorCode: 'already_owned',
          errorMessage: 'Already owned');
      _ctrl.add(r);
      onEvent
          ?.call('purchase_failed', {'sku': sku.id, 'reason': 'already_owned'});
      return r;
    }
    // Failure injection
    if (failureCodes.containsKey(sku.id)) {
      final r = PurchaseResult(
          state: PurchaseState.failed,
          skuId: sku.id,
          errorCode: failureCodes[sku.id]);
      _ctrl.add(r);
      onEvent?.call(
          'purchase_failed', {'sku': sku.id, 'reason': failureCodes[sku.id]});
      return r;
    }
    // Simulate success
    final orderId =
        'MOCK-${DateTime.now().millisecondsSinceEpoch}-${_rand.nextInt(99999)}';
    if (sku.type == SkuType.nonConsumable) {
      _ownedNonConsumables.add(sku.id);
    }
    final r = PurchaseResult(
        state: PurchaseState.success, skuId: sku.id, orderId: orderId);
    _ctrl.add(r);
    onEvent?.call('purchase_success', {
      'sku': sku.id,
      'type': sku.type.toString().split('.').last,
      'orderId': orderId,
      'priceMicros': sku.price.amountMicros,
      'currency': sku.price.currencyCode,
    });
    return r;
  }

  @override
  Future<List<PurchaseReceipt>> restorePurchases() async {
    await Future<void>.delayed(latency);
    return _ownedNonConsumables
        .map((skuId) => PurchaseReceipt(
              transactionId: 'RESTORE-$skuId',
              skuId: skuId,
              purchaseTime: DateTime.now(),
            ))
        .toList();
  }

  void dispose() {
    _ctrl.close();
  }
}

/// Decorator that wraps a [MonetizationGatewayPort] to emit analytics events using a callback.
class AnalyticsMonetizationDecorator implements MonetizationGatewayPort {
  final MonetizationGatewayPort _inner;
  final void Function(String event, Map<String, Object?> props)? onEvent;
  AnalyticsMonetizationDecorator(this._inner, {this.onEvent});

  @override
  Stream<PurchaseResult> get purchaseStream => _inner.purchaseStream;

  @override
  Future<Availability> availability(String skuId,
          {Map<String, Object?> context = const {}}) =>
      _inner.availability(skuId, context: context);

  @override
  Future<PurchaseResult> checkout(CheckoutRequest req) async {
    final result = await _inner.checkout(req);
    onEvent?.call(
        result.isSuccess ? 'purchase_success' : 'purchase_${result.state.name}',
        {
          'sku': result.skuId,
          if (result.orderId != null) 'orderId': result.orderId,
          if (result.errorCode != null) 'reason': result.errorCode,
        });
    return result;
  }

  @override
  Future<List<PurchaseReceipt>> restorePurchases() => _inner.restorePurchases();

  @override
  Future<List<Sku>> listSkus({String? tag}) => _inner.listSkus(tag: tag);
}
