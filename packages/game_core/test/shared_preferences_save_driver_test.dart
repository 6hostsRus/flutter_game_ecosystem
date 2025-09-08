import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:game_core/core/shared_preferences_save_driver.dart';

void main() {
  test('SharedPreferencesSaveDriver save/load/delete round trip', () async {
    // Use mock initial values to avoid platform channel usage.
    SharedPreferences.setMockInitialValues({});
    final driver = await SharedPreferencesSaveDriver.create();

    expect(await driver.load('k'), isNull);
    await driver.save('k', 'v1');
    expect(await driver.load('k'), 'v1');
    await driver.save('k', 'v2');
    expect(await driver.load('k'), 'v2');
    await driver.delete('k');
    expect(await driver.load('k'), isNull);
  });
}
