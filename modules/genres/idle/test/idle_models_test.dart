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

  test('Generator toJson/fromJson round trip', () {
    final g = Generator(
        id: 'g',
        level: 2,
        baseRatePerSec: 3.5,
        multiplier: 1.2,
        unlocked: true);
    final j = g.toJson();
    final g2 = Generator.fromJson(Map<String, Object?>.from(j));
    expect(g2.id, 'g');
    expect(g2.level, 2);
    expect(g2.baseRatePerSec, closeTo(3.5, 1e-9));
    expect(g2.multiplier, closeTo(1.2, 1e-9));
    expect(g2.unlocked, isTrue);
  });

  test('IdleState toJson/fromJson round trip', () {
    final s = IdleState(
      lastSeen: DateTime.fromMillisecondsSinceEpoch(1000),
      softCurrency: 42.0,
      prestigePoints: 7,
      generators: [Generator(id: 'a', level: 1)],
    );
    final j = s.toJson();
    final s2 = IdleState.fromJson(Map<String, Object?>.from(j));
    expect(s2.lastSeen.millisecondsSinceEpoch, 1000);
    expect(s2.softCurrency, closeTo(42.0, 1e-9));
    expect(s2.prestigePoints, 7);
    expect(s2.generators.length, 1);
    expect(s2.generators.first.id, 'a');
  });

  test('Component conversion provides ECS-friendly shapes', () {
    final g = Generator(
        id: 'g',
        level: 3,
        baseRatePerSec: 2.0,
        multiplier: 1.1,
        unlocked: true);
    final s = IdleState(
        lastSeen: DateTime.fromMillisecondsSinceEpoch(500),
        softCurrency: 5.0,
        prestigePoints: 1);
    final gc = g.toComponent();
    final sc = s.toComponent();
    expect(gc.id, 'g');
    expect(gc.level, 3);
    expect(gc.ratePerSec, closeTo(2.0, 1e-9));
    expect(gc.multiplier, closeTo(1.1, 1e-9));
    expect(gc.unlocked, isTrue);
    expect(sc.epochMillis, 500);
    expect(sc.softCurrency, closeTo(5.0, 1e-9));
    expect(sc.prestigePoints, 1);
  });
}
