library services.test_support.perf_harness;

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_services/core_services.dart';
import 'package:services/economy/simple_economy.dart';
import 'package:services/monetization/sku_rewards.dart';
import 'package:services/monetization/gateway_port.dart';

/// Deterministic simulation harness to exercise basic economy + rewards flows.
///
/// - Uses a fixed RNG seed for reproducibility.
/// - Performs a mix of award/spend operations and simulated IAP rewards.
/// - Writes a small metrics JSON to build/metrics/perf_simulation.json.
class PerfHarness {
  final ProviderContainer container;
  final SimpleEconomy economy;
  final Random _rng;

  int ticks = 0;
  int awards = 0;
  int spends = 0;
  int purchases = 0;
  int failedSpends = 0;

  PerfHarness._(this.container, this.economy, this._rng);

  factory PerfHarness({int seed = 1337}) {
    final container = ProviderContainer();
    final econ = SimpleEconomy();
    return PerfHarness._(container, econ, Random(seed));
  }

  WalletState get wallet => container.read(walletProvider);

  /// Run [count] ticks. Each tick performs one action.
  void runTicks(int count) {
    for (var i = 0; i < count; i++) {
      ticks++;
      final roll = _rng.nextDouble();
      if (roll < 0.45) {
        // Award 1..5 coins.
        final amt = 1 + _rng.nextInt(5);
        economy.award('coins', amt, reason: 'tick');
        final w = container.read(walletProvider.notifier);
        w.addCoins(amt.toDouble());
        awards++;
      } else if (roll < 0.8) {
        // Spend 1..3 coins if available.
        final amt = 1 + _rng.nextInt(3);
        if (wallet.coins >= amt) {
          economy.spend('coins', amt, reason: 'tick');
          final w = container.read(walletProvider.notifier);
          w.setState(wallet.copyWith(coins: wallet.coins - amt));
          spends++;
        } else {
          failedSpends++;
        }
      } else {
        // Simulate an IAP reward (e.g., coins_100) with dedupe by order id.
        final orderId = 'ord_${ticks}_${_rng.nextInt(3)}';
        final result = PurchaseResult(
          skuId: 'coins_100',
          state: PurchaseState.success,
          orderId: orderId,
        );
        final applied = applyRewardForPurchase(container.read, result);
        if (applied) purchases++;
      }

      // Light CPU work to emulate processing cost without slowing too much.
      _spin(200 + _rng.nextInt(200));
    }
  }

  Map<String, dynamic> snapshot() => {
        'ticks': ticks,
        'awards': awards,
        'spends': spends,
        'failedSpends': failedSpends,
        'purchases': purchases,
        'wallet': {'coins': wallet.coins, 'premium': wallet.premium},
        'rewardEvents': container.read(rewardEventsCountProvider),
      };

  void writeMetrics() {
    final out = File('build/metrics/perf_simulation.json');
    out.parent.createSync(recursive: true);
    out.writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(snapshot()));
  }

  static void _spin(int n) {
    // Simple deterministic busy-loop that is stable across platforms enough for unit tests.
    var x = 0;
    for (var i = 0; i < n; i++) {
      x = (x + i) & 0xFFFF;
    }
    if (x == -1) stdout.writeln('');
  }
}
