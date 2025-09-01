library services.profile_store;

class ProfileKey {
  final String namespace;
  final String name;
  const ProfileKey(this.namespace, this.name);
  @override
  String toString() => '$namespace/$name';
}

class ProfileRecord {
  final int version;
  final Map<String, dynamic> data;
  const ProfileRecord({required this.version, required this.data});
}

abstract class ProfileMigration {
  int get from;
  int get to;
  Map<String, dynamic> migrate(Map<String, dynamic> input);
}

class ProfileBackup {
  final List<int> bytes;
  const ProfileBackup(this.bytes);
}

abstract class ProfileStore {
  ProfileRecord? read(ProfileKey key);
  void write(ProfileKey key, ProfileRecord record);
  void delete(ProfileKey key);

  void registerMigration(String namespace, ProfileMigration migration);
  void migrateNamespace(String namespace);

  ProfileBackup backup();
  void restore(ProfileBackup backup);
}
