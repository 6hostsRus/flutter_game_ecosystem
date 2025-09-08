import 'package:shared_preferences/shared_preferences.dart';
import 'save_driver.dart';

/// SaveDriver implementation that uses `shared_preferences` for persistence.
class SharedPreferencesSaveDriver implements SaveDriver {
  final SharedPreferences _prefs;

  SharedPreferencesSaveDriver._(this._prefs);

  /// Creates an instance by loading the shared preferences instance.
  static Future<SharedPreferencesSaveDriver> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesSaveDriver._(prefs);
  }

  @override
  Future<void> save(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> load(String key) async => _prefs.getString(key);

  @override
  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }
}
