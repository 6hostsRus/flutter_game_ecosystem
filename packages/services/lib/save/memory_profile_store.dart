library services.memory_profile_store;

import 'profile_store.dart';

class InMemoryProfileStore implements ProfileStore {
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
    final migrations = _migrations[namespace];
    if (migrations == null || migrations.isEmpty) return;
    // Very naive migration: for each record in namespace, apply migrations sequentially.
    final keys =
        _records.keys.where((k) => k.startsWith('$namespace/')).toList();
    for (final key in keys) {
      final rec = _records[key]!;
      var data = rec.data;
      var version = rec.version;
      for (final m in migrations..sort((a, b) => a.from.compareTo(b.from))) {
        if (version == m.from) {
          data = m.migrate(data);
          version = m.to;
        }
      }
      _records[key] = ProfileRecord(version: version, data: data);
    }
  }

  @override
  ProfileBackup backup() {
    // Not space efficient; fine for tests.
    final bytes = _records.entries
        .expand((e) =>
            e.key.codeUnits + [0] + e.value.version.toString().codeUnits + [0])
        .toList();
    return ProfileBackup(bytes);
  }

  @override
  void restore(ProfileBackup backup) {
    // No-op simplistic restore (not needed yet).
  }
}
