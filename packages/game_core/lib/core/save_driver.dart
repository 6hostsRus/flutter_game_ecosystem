/// Abstract driver for simple key/value persistence.
abstract class SaveDriver {
  Future<void> save(String key, String value);
  Future<String?> load(String key);
  Future<void> delete(String key);
}

/// In-memory save driver for tests and demos.
class InMemorySaveDriver implements SaveDriver {
  final Map<String, String> _store = <String, String>{};

  @override
  Future<void> save(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<String?> load(String key) async => _store[key];

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }
}
