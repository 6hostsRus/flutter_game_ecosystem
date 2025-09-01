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

  MockDevMonetizationAdapter(
    List<Sku> skus, {
    this.failureCodes = const {},
    this.latency = const Duration(milliseconds: 200),
  }) : _skus = {for (final s in skus) s.id: s};

  @override
  Stream<PurchaseResult> get purchaseStream => _ctrl.stream;

  @override
  Future<List<Sku>> listSkus({String? tag}) async {
    await Future<void>.delayed(latency);
    final list = _skus.values.where((s) => tag == null || s.tags.contains(tag)).toList();
    list.sort((a, b) => a.price.amountMicros.compareTo(b.price.amountMicros));
    return list;
  }

  @override
  Future<Availability> availability(String skuId, {Map<String, Object?> context = const {}}) async {
    await Future<void>.delayed(latency);
    final sku = _skus[skuId];
    if (sku == null) return Availability(skuId, false, reason: 'unknown_sku');
    if (sku.type == SkuType.nonConsumable && _ownedNonConsumables.contains(skuId)) {
      return Availability(skuId, false, reason: 'owned');
    }
    return Availability(skuId, true);
  }

  @override
  Future<PurchaseResult> checkout(CheckoutRequest req) async {
    await Future<void>.delayed(latency);
    final sku = _skus[req.skuId];
    if (sku == null) {
      final r = PurchaseResult(state: PurchaseState.failed, skuId: req.skuId, errorCode: 'unknown_sku', errorMessage: 'SKU not found');
      _ctrl.add(r);
      return r;
    }
    // Non-consumable guard
    if (sku.type == SkuType.nonConsumable && _ownedNonConsumables.contains(sku.id)) {
      final r = PurchaseResult(state: PurchaseState.failed, skuId: sku.id, errorCode: 'already_owned', errorMessage: 'Already owned');
      _ctrl.add(r);
      return r;
    }
    // Failure injection
    if (failureCodes.containsKey(sku.id)) {
      final r = PurchaseResult(state: PurchaseState.failed, skuId: sku.id, errorCode: failureCodes[sku.id]);
      _ctrl.add(r);
      return r;
    }
    // Simulate success
    final orderId = 'MOCK-${DateTime.now().millisecondsSinceEpoch}-${_rand.nextInt(99999)}';
    if (sku.type == SkuType.nonConsumable) {
      _ownedNonConsumables.add(sku.id);
    }
    final r = PurchaseResult(state: PurchaseState.success, skuId: sku.id, orderId: orderId);
    _ctrl.add(r);
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
