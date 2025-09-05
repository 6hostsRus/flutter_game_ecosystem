import 'package:flutter_test/flutter_test.dart';
import 'package:services/save/profile_store.dart';
import 'package:services/save/memory_profile_store.dart';

class BalanceMigration extends ProfileMigration {
  @override
  int get from => 1;
  @override
  int get to => 2;
  @override
  Map<String, dynamic> migrate(Map<String, dynamic> input) {
    // Add a migrated flag
    final copy = Map<String, dynamic>.from(input);
    copy['migrated'] = true;
    return copy;
  }
}

void main() {
  test('InMemoryProfileStore migration applies sequentially', () {
    final store = InMemoryProfileStore();
    final key = const ProfileKey('economy', 'balances');
    store.write(
        key,
        const ProfileRecord(version: 1, data: {
          'balances': {'coins': 10}
        }));
    store.registerMigration('economy', BalanceMigration());
    store.migrateNamespace('economy');
    final rec = store.read(key)!;
    expect(rec.version, 2);
    expect(rec.data['migrated'], true);
  });
}
