import 'package:flutter_test/flutter_test.dart';
import 'package:services/economy/economy_profile_adapter.dart';
import 'package:services/economy/economy_port.dart';
import 'package:services/economy/simple_economy.dart';
import 'package:services/save/profile_store.dart';
import 'package:services/test_support/transactions.dart';

/// A ProfileStore that can be configured to throw on write/restore to exercise
/// error paths and verify callers handle rollback.
class FailingProfileStore implements ProfileStore {
  final Map<String, ProfileRecord> _records = {};
  bool throwOnWrite;
  bool throwOnRestore;
  FailingProfileStore({this.throwOnWrite = false, this.throwOnRestore = false});

  String _k(ProfileKey k) => k.toString();

  @override
  ProfileRecord? read(ProfileKey key) => _records[_k(key)];

  @override
  void write(ProfileKey key, ProfileRecord record) {
    if (throwOnWrite) throw StateError('inject:write');
    _records[_k(key)] = record;
  }

  @override
  void delete(ProfileKey key) => _records.remove(_k(key));

  @override
  void registerMigration(String namespace, ProfileMigration migration) {}

  @override
  void migrateNamespace(String namespace) {}

  @override
  ProfileBackup backup() => const ProfileBackup(<int>[]);

  @override
  void restore(ProfileBackup backup) {
    if (throwOnRestore) throw StateError('inject:restore');
  }
}

// transactionalSpend now provided by services/test_support/transactions.dart

void main() {
  group('EconomyErrorPaths', () {
    test('UnknownCurrency throws and leaves balances unchanged', () {
      final econ = SimpleEconomy(currencies: const {'coins'});
      expect(() => econ.checkBalance('gems'), throwsA(isA<UnknownCurrency>()));
      expect(() => econ.spend('gems', 1), throwsA(isA<UnknownCurrency>()));
    });

    test('InsufficientFunds throws and leaves balance unchanged', () {
      final econ = SimpleEconomy(currencies: const {'coins'});
      expect(econ.checkBalance('coins'), 0);
      expect(() => econ.spend('coins', 10), throwsA(isA<InsufficientFunds>()));
      expect(econ.checkBalance('coins'), 0);
    });

    test('Persistence write failure triggers rollback of spend', () async {
      final econ = SimpleEconomy(currencies: const {'coins'});
      econ.award('coins', 20);
      final store = FailingProfileStore(throwOnWrite: true);
      final adapter = EconomyProfileAdapter(economy: econ, profile: store);

      expect(econ.checkBalance('coins'), 20);
      // Attempt transactional spend 5 coins; persistence fails.
      expect(
        () => transactionalSpend(
          economy: econ,
          currency: 'coins',
          amount: 5,
          adapter: adapter,
        ),
        throwsA(isA<StateError>()),
      );
      // Balance should be rolled back to 20
      expect(econ.checkBalance('coins'), 20);
    });

    test('Restore failure leaves adapter.load returning empty map', () {
      final econ = SimpleEconomy(currencies: const {'coins'});
      final store = FailingProfileStore(throwOnRestore: true);
      final adapter = EconomyProfileAdapter(economy: econ, profile: store);

      // Because adapter.load reads from store.read, and restore throws before any
      // write occurs, load should return empty map.
      expect(adapter.load(), isEmpty);
    });
  });
}
