import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';

void main() {
  test('IdleTimeService computes yield with cap and clock', () {
    final start = DateTime(2024, 1, 1, 0, 0, 0);
    final clock = FakeClock(start.millisecondsSinceEpoch);
    final svc = IdleTimeService(clock: clock);

    // No time passed -> zero yield
    expect(svc.computeOfflineYield(start, 2.0), 0);

    // Advance 10 seconds -> yield 20
    clock.advance(10 * 1000);
    expect(svc.computeOfflineYield(start, 2.0), 20);

    // Cap applies: with small cap, result clamps
    expect(svc.computeOfflineYield(start, 2.0, capSeconds: 5), 10);
  });
}
