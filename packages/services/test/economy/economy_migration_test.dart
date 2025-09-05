import 'package:flutter_test/flutter_test.dart';
import 'package:services/economy/economy_profile_adapter.dart';
import 'package:services/economy/simple_economy.dart';
import 'package:services/save/profile_store.dart';
import 'package:services/save/memory_profile_store.dart';

class AddPremiumCurrencyMigration extends ProfileMigration {
  @override
  int get from => 1;
  @override
  int get to => 2;
  @override
  Map<String, dynamic> migrate(Map<String, dynamic> input) {
    final copy = Map<String, dynamic>.from(input);
    final balances = Map<String, dynamic>.from(
        (copy['balances'] as Map).cast<String, dynamic>());
    // Introduce a new currency with starting balance 0 if absent.
    balances.putIfAbsent('premium', () => 0);
    copy['balances'] = balances;
    copy['migrationApplied'] = true;
    return copy;
  }
}

void main() {
  group('EconomyMigration', () {
    test('applies migration 1->2 and preserves existing balances', () {
      final store = InMemoryProfileStore();
      final econ = SimpleEconomy(currencies: const {'coins', 'premium'});
      // Seed legacy (v1) record lacking premium currency.
      store.write(
        const ProfileKey('economy', 'balances'),
        const ProfileRecord(version: 1, data: {
          'balances': {'coins': 25},
        }),
      );
      // Register and apply migration.
      store.registerMigration('economy', AddPremiumCurrencyMigration());
      store.migrateNamespace('economy');

      final rec = store.read(const ProfileKey('economy', 'balances'))!;
      expect(rec.version, 2);
      expect(rec.data['migrationApplied'], true);
      final adapter = EconomyProfileAdapter(economy: econ, profile: store);
      final loaded = adapter.load();
      // coins preserved, premium defaulted.
      expect(loaded['coins'], 25);
      expect(loaded['premium'], 0);
    });
  });
}
