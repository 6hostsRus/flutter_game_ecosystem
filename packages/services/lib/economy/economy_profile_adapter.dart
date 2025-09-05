library services.economy_profile_adapter;

import 'dart:convert';
import 'economy_port.dart';
import '../save/profile_store.dart';

/// Persists balances of an [EconomyPort] into a [ProfileStore].
/// Stores under namespace 'economy', key 'balances' with versioned payload.
class EconomyProfileAdapter {
  static const _ns = 'economy';
  static const _balancesKey = ProfileKey(_ns, 'balances');
  final EconomyPort economy;
  final ProfileStore profile;

  EconomyProfileAdapter({required this.economy, required this.profile});

  /// Saves provided currency balances snapshot.
  void save(Map<String, int> balances, {int version = 1}) {
    profile.write(_balancesKey,
        ProfileRecord(version: version, data: {'balances': balances}));
  }

  /// Loads balances map or empty map if missing.
  Map<String, int> load() {
    final rec = profile.read(_balancesKey);
    if (rec == null) return {};
    final raw = rec.data['balances'];
    if (raw is Map<String, dynamic>) {
      return raw.map((k, v) => MapEntry(k, (v as num).toInt()));
    }
    return {};
  }

  /// Exports balances JSON for external persistence / analytics.
  String exportJson() => jsonEncode(load());
}
