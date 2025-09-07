library services.test_support.transactions;

import 'package:services/economy/economy_port.dart';
import 'package:services/economy/economy_profile_adapter.dart';

/// Performs a spend and attempts to persist balances using [adapter].
/// If persistence fails, reverts the spend to the previous balance and rethrows.
Future<void> transactionalSpend({
  required EconomyPort economy,
  required String currency,
  required int amount,
  required EconomyProfileAdapter adapter,
}) async {
  final before = economy.checkBalance(currency);
  economy.spend(currency, amount);
  try {
    adapter.save({currency: economy.checkBalance(currency)});
  } catch (e) {
    final delta = before - economy.checkBalance(currency);
    if (delta != 0) {
      economy.award(currency, delta, reason: 'rollback');
    }
    rethrow;
  }
}
