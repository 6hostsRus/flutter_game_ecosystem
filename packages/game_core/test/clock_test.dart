import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';

void main() {
  group('Clock', () {
    test('SystemClock now returns near current time', () {
      final clock = const SystemClock();
      final before = DateTime.now().millisecondsSinceEpoch;
      final t = clock.nowMillis();
      final after = DateTime.now().millisecondsSinceEpoch;
      expect(t, inInclusiveRange(before, after));
    });

    test('FakeClock advance moves time forward deterministically', () {
      final start = DateTime(2024, 1, 1).millisecondsSinceEpoch;
      final clock = FakeClock(start);
      expect(clock.nowMillis(), start);
      clock.advance(1500);
      expect(clock.nowMillis(), start + 1500);
      clock.advance(500);
      expect(clock.nowMillis(), start + 2000);
    });
  });
}
