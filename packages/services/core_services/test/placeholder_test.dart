import 'package:flutter_test/flutter_test.dart';
import 'package:core_services/core_services.dart';

void main() {
  test('WalletNotifier add/spend coins', () {
    final notifier = WalletNotifier();
    notifier.addCoins(100);
    expect(notifier.state.coins, 100);
    notifier.spendCoins(40);
    expect(notifier.state.coins, 60);
  });
}
