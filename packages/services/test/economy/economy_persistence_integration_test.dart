import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:services/economy/simple_economy.dart';
import 'package:services/economy/economy_profile_adapter.dart';
import 'package:services/save/profile_store.dart';

/// In-memory profile store for test verifying persistence round-trip.
class MemoryProfileStore implements ProfileStore {
  final Map<String, ProfileRecord> _records = {};
  final Map<String, List<ProfileMigration>> _migrations = {};

  String _key(ProfileKey k) => k.toString();

  @override
  ProfileRecord? read(ProfileKey key) => _records[_key(key)];

  @override
  void write(ProfileKey key, ProfileRecord record) {
    _records[_key(key)] = record;
  }

  @override
  void delete(ProfileKey key) => _records.remove(_key(key));

  @override
  void registerMigration(String namespace, ProfileMigration migration) {
    _migrations.putIfAbsent(namespace, () => []).add(migration);
  }

  @override
  void migrateNamespace(String namespace) {
    final migs = _migrations[namespace];
    if (migs == null || migs.isEmpty) return;
    // For each record in namespace, apply chained migrations in order.
    final keys =
        _records.keys.where((k) => k.startsWith('$namespace/')).toList();
    for (final k in keys) {
      final rec = _records[k]!;
      var data = rec.data;
      var version = rec.version;
      for (final m in migs..sort((a, b) => a.from.compareTo(b.from))) {
        if (version == m.from) {
          data = m.migrate(data);
          version = m.to;
        }
      }
      _records[k] = ProfileRecord(version: version, data: data);
    }
  }

  @override
  ProfileBackup backup() => ProfileBackup(utf8.encode(jsonEncode({
        'records': _records.map((k, v) => MapEntry(k, {
              'version': v.version,
              'data': v.data,
            }))
      })));

  @override
  void restore(ProfileBackup backup) {
    final decoded = jsonDecode(utf8.decode(backup.bytes)) as Map;
    final map = decoded['records'] as Map;
    _records.clear();
    map.forEach((k, v) {
      final m = v as Map;
      _records[k as String] = ProfileRecord(
          version: (m['version'] as num).toInt(),
          data: (m['data'] as Map).cast<String, dynamic>());
    });
  }
}

void main() {
  group('EconomyPersistenceIntegration', () {
    test('save -> load round trip with multiple currencies', () {
      final econ =
          SimpleEconomy(currencies: const {'coins', 'premium', 'gems'});
      econ.award('coins', 50);
      econ.award('premium', 3);
      econ.award('gems', 7);
      final store = MemoryProfileStore();
      final adapter = EconomyProfileAdapter(economy: econ, profile: store);

      // Simulate snapshot save
      final snapshot = {
        'coins': econ.checkBalance('coins'),
        'premium': econ.checkBalance('premium'),
        'gems': econ.checkBalance('gems'),
      };
      adapter.save(snapshot, version: 1);

      // Load into fresh adapter/store to verify persistence
      final store2 = MemoryProfileStore();
      store2.restore(store.backup());
      final adapter2 = EconomyProfileAdapter(economy: econ, profile: store2);
      final loaded = adapter2.load();
      expect(loaded, equals(snapshot));
    });
  });
}
