import 'package:flutter_test/flutter_test.dart';
import 'package:idle/idle.dart';

void main() {
  test('Generator defaults and cost curve', () {
    final g = Generator(id: 'g1');
    expect(g.level, 0);
    expect(g.baseRatePerSec, 0.0);
    expect(g.multiplier, 1.0);
    expect(g.unlocked, isFalse);
    expect(g.costCurve(1), closeTo(11.5, 1e-9));
  });

  test('IdleState defaults', () {
    final s = IdleState();
    expect(s.softCurrency, 0.0);
    expect(s.prestigePoints, 0);
    expect(s.generators, isEmpty);
    expect(s.lastSeen, isA<DateTime>());
  });
}
