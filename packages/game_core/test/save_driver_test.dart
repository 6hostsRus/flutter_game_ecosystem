import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';

void main() {
  test('InMemorySaveDriver save/load/delete round trip', () async {
    final d = InMemorySaveDriver();
    expect(await d.load('k'), isNull);
    await d.save('k', 'v1');
    expect(await d.load('k'), 'v1');
    await d.save('k', 'v2');
    expect(await d.load('k'), 'v2');
    await d.delete('k');
    expect(await d.load('k'), isNull);
  });
}
