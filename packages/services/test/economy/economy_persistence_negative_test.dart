import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:services/economy/economy_profile_adapter.dart';
import 'package:services/economy/simple_economy.dart';
import 'package:services/save/profile_store.dart';

/// Local test-only profile store with JSON backup/restore (duplicated on purpose
/// to allow corruption scenarios without affecting prod `InMemoryProfileStore`).
class JsonMemoryProfileStore implements ProfileStore {
  final Map<String, ProfileRecord> _records = {};
  final Map<String, List<ProfileMigration>> _migrations = {};

  String _k(ProfileKey k) => k.toString();

  @override
  ProfileRecord? read(ProfileKey key) => _records[_k(key)];

  @override
  void write(ProfileKey key, ProfileRecord record) =>
      _records[_k(key)] = record;

  @override
  void delete(ProfileKey key) => _records.remove(_k(key));

  @override
  void registerMigration(String namespace, ProfileMigration migration) {
    _migrations.putIfAbsent(namespace, () => []).add(migration);
  }

  @override
  void migrateNamespace(String namespace) {
    final migs = _migrations[namespace];
    if (migs == null || migs.isEmpty) return;
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
    final map = decoded['records'] as Map? ?? {};
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
  group('EconomyPersistenceNegative', () {
    test('corrupted backup bytes throw and result in empty load', () {
      final econ = SimpleEconomy(currencies: const {'coins', 'gems'});
      econ.award('coins', 10);
      econ.award('gems', 5);
      final store = JsonMemoryProfileStore();
      final adapter = EconomyProfileAdapter(economy: econ, profile: store);
      adapter.save({
        'coins': econ.checkBalance('coins'),
        'gems': econ.checkBalance('gems'),
      }, version: 1);
      final backup = store.backup();
      // Corrupt by truncating substantial tail.
      final corruptBytes = backup.bytes.sublist(0, backup.bytes.length ~/ 2);
      final store2 = JsonMemoryProfileStore();
      bool threw = false;
      try {
        store2.restore(ProfileBackup(corruptBytes));
      } catch (_) {
        threw = true;
      }
      expect(threw, true, reason: 'restore should throw on corrupted JSON');
      final adapter2 = EconomyProfileAdapter(economy: econ, profile: store2);
      expect(adapter2.load(), isEmpty);
    });
  });
}
