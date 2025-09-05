import 'package:flutter_test/flutter_test.dart';
import 'package:services/economy/economy_port.dart';
import 'package:services/economy/simple_economy.dart';

void main() {
  group('SimpleEconomy', () {
    test('award then spend success path', () {
      final econ = SimpleEconomy();
      expect(econ.checkBalance('coins'), 0);
      econ.award('coins', 150, reason: 'quest');
      expect(econ.checkBalance('coins'), 150);
      econ.spend('coins', 40, reason: 'buy');
      expect(econ.checkBalance('coins'), 110);
    });

    test('spend insufficient funds throws', () {
      final econ = SimpleEconomy();
      expect(() => econ.spend('coins', 1), throwsA(isA<InsufficientFunds>()));
    });

    test('unknown currency throws', () {
      final econ = SimpleEconomy();
      expect(() => econ.checkBalance('gems'), throwsA(isA<UnknownCurrency>()));
    });

    test('offer catalog immutable', () {
      final econ = SimpleEconomy(offers: const [Offer(sku: 'starter')]);
      expect(econ.offerCatalog().length, 1);
      expect(() => econ.offerCatalog().add(const Offer(sku: 'x')),
          throwsUnsupportedError);
    });
  });
}
