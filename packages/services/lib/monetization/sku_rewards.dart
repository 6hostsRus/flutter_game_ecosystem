// Central SKU reward logic with external config, dedupe persistence, and reward event metrics.
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'gateway_port.dart';
import 'package:core_services/core_services.dart';

enum RewardType { coins, premium }

class RewardSpec {
  final RewardType type;
  final int amount;
  const RewardSpec(this.type, this.amount);

  factory RewardSpec.fromJson(Map<String, dynamic> json) => RewardSpec(
        RewardType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => RewardType.coins,
        ),
        (json['amount'] as num).toInt(),
      );
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'amount': amount,
      };
}

// Default embedded mapping used when JSON config absent.
const Map<String, RewardSpec> _defaultRewards = {
  'coins_100': RewardSpec(RewardType.coins, 100),
  'premium_5': RewardSpec(RewardType.premium, 5),
};

final _skuRewardsCacheProvider = Provider<Map<String, RewardSpec>>((ref) {
  final file = File('packages/services/lib/monetization/sku_rewards.json');
  if (file.existsSync()) {
    try {
      final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      return data.map((k, v) => MapEntry(k, RewardSpec.fromJson(v)));
    } catch (_) {
      // Fallback to default on parse errors.
    }
  }
  return _defaultRewards;
});

// Reward events counter for metrics.
final rewardEventsCountProvider = StateProvider<int>((_) => 0);

// Dedupe store abstraction (persist order IDs across restarts when possible).
abstract class PurchaseDedupeStore {
  bool isProcessed(String orderId);
  bool markProcessed(String orderId); // returns true if newly added
}

class InMemoryPurchaseDedupeStore implements PurchaseDedupeStore {
  final Set<String> _ids = {};
  @override
  bool isProcessed(String orderId) => _ids.contains(orderId);
  @override
  bool markProcessed(String orderId) => _ids.add(orderId);
}

class FilePurchaseDedupeStore implements PurchaseDedupeStore {
  final File file;
  late final Set<String> _ids;
  FilePurchaseDedupeStore(this.file) {
    if (file.existsSync()) {
      try {
        final list = jsonDecode(file.readAsStringSync()) as List<dynamic>;
        _ids = list.map((e) => e.toString()).toSet();
      } catch (_) {
        _ids = <String>{};
      }
    } else {
      _ids = <String>{};
    }
  }
  void _flush() {
    try {
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(jsonEncode(_ids.toList()));
    } catch (_) {}
  }

  @override
  bool isProcessed(String orderId) => _ids.contains(orderId);
  @override
  bool markProcessed(String orderId) {
    final added = _ids.add(orderId);
    if (added) _flush();
    return added;
  }
}

final purchaseDedupeStoreProvider =
    Provider<PurchaseDedupeStore>((_) => InMemoryPurchaseDedupeStore());

typedef Reader = T Function<T>(ProviderListenable<T> provider);

/// Apply reward if purchase successful and not already processed.
bool applyRewardForPurchase(Reader ref, PurchaseResult result) {
  if (!result.isSuccess) return false;
  final rewards = ref(_skuRewardsCacheProvider);
  final spec = rewards[result.skuId];
  if (spec == null) return false;
  final orderId = result.orderId ?? '${result.skuId}_${result.state}';
  final store = ref(purchaseDedupeStoreProvider);
  if (!store.markProcessed(orderId)) return false; // duplicate

  final wallet = ref(walletProvider.notifier);
  switch (spec.type) {
    case RewardType.coins:
      wallet.addCoins(spec.amount.toDouble());
      break;
    case RewardType.premium:
      final current = ref(walletProvider);
      wallet.setState(WalletState(
          coins: current.coins, premium: current.premium + spec.amount));
      break;
  }

  // Increment reward counter and persist simple metric file.
  final count = ref(rewardEventsCountProvider.notifier);
  count.state = count.state + 1;
  try {
    final metricsFile = File('build/metrics/reward_events_count.txt');
    metricsFile.parent.createSync(recursive: true);
    final current = metricsFile.existsSync()
        ? int.tryParse(metricsFile.readAsStringSync()) ?? 0
        : 0;
    metricsFile.writeAsStringSync('${current + 1}');
  } catch (_) {}
  return true;
}
