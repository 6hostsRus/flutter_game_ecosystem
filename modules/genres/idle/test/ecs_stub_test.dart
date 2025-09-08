import 'package:flutter_test/flutter_test.dart';
import 'package:idle/idle.dart';

void main() {
  test('IdleIncomeSystem tick accumulates soft currency from generators', () {
    final world = World();

    // Create idle state entity
    final s = IdleState(
        lastSeen: DateTime.fromMillisecondsSinceEpoch(0),
        softCurrency: 0,
        prestigePoints: 0);
    final se = world.createEntity();
    se.set<IdleStateComponentData>(s.toComponent());

    // Two generators
    final g1 = Generator(
        id: 'a',
        level: 1,
        baseRatePerSec: 2.0,
        multiplier: 1.0,
        unlocked: true);
    final e1 = world.createEntity();
    e1.set<GeneratorComponentData>(g1.toComponent());

    final g2 = Generator(
        id: 'b',
        level: 1,
        baseRatePerSec: 1.0,
        multiplier: 2.0,
        unlocked: true);
    final e2 = world.createEntity();
    e2.set<GeneratorComponentData>(g2.toComponent());

    // Simulate 5 seconds
    IdleIncomeSystem.tick(world, 5.0);

    final updated = se.get<IdleStateComponentData>()!;
    // delta = (2*1 + 1*2) * 5 = (2 + 2) * 5 = 20
    expect(updated.softCurrency, closeTo(20.0, 1e-9));
  });
}
