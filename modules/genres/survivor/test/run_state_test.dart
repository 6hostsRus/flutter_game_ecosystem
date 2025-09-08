import 'package:flutter_test/flutter_test.dart';
import 'package:survivor/survivor.dart';

void main() {
  group('SurvivorRunState', () {
    test('defaults and copyWith', () {
      const s = SurvivorRunState();
      expect(s.wave, 0);
      expect(s.timeSec, 0);
      expect(s.damagePerSec, 1);
      expect(s.health, 100);
      final s2 = s.copyWith(damagePerSec: 2.5);
      expect(s2.damagePerSec, 2.5);
      expect(s2.wave, 0);
    });

    test('tick advances time, applies damage, and increments wave every 30s',
        () {
      var s = const SurvivorRunState(damagePerSec: 2, health: 10);
      s = s.tick(1); // 1s, -2 hp
      expect(s.timeSec, closeTo(1, 1e-9));
      expect(s.health, closeTo(8, 1e-9));
      expect(s.wave, 0);

      s = s.tick(29); // cross 30s boundary
      expect(s.timeSec, closeTo(30, 1e-9));
      expect(s.wave, 1);
    });

    test('isDead after sufficient damage', () {
      var s = const SurvivorRunState(damagePerSec: 50, health: 10);
      s = s.tick(0.2); // -10 hp
      expect(s.health, closeTo(0, 1e-9));
      expect(s.isDead, isTrue);
    });

    test('toJson/fromJson round trip', () {
      const s = SurvivorRunState(
          wave: 3,
          timeSec: 45.5,
          damagePerSec: 1.2,
          health: 77,
          dpsGrowthPerWave: 0.1,
          spawnGrowthPerWave: 0.05);
      final j = s.toJson();
      final s2 = SurvivorRunState.fromJson(Map<String, Object?>.from(j));
      expect(s2.wave, s.wave);
      expect(s2.timeSec, closeTo(s.timeSec, 1e-9));
      expect(s2.damagePerSec, closeTo(s.damagePerSec, 1e-9));
      expect(s2.health, closeTo(s.health, 1e-9));
      expect(s2.dpsGrowthPerWave, closeTo(s.dpsGrowthPerWave, 1e-9));
      expect(s2.spawnGrowthPerWave, closeTo(s.spawnGrowthPerWave, 1e-9));
    });

    test('difficulty scaling increases effective DPS and spawn multiplier', () {
      var s = const SurvivorRunState(
        damagePerSec: 10,
        dpsGrowthPerWave: 0.2, // +20% DPS per wave
        spawnGrowthPerWave: 0.5, // +50% spawn per wave
      );
      expect(s.effectiveDps, closeTo(10, 1e-9));
      expect(s.spawnRateMultiplier, closeTo(1, 1e-9));
      // Advance to wave 1 (30s)
      s = s.tick(30);
      expect(s.wave, 1);
      expect(s.effectiveDps, closeTo(12, 1e-9));
      expect(s.spawnRateMultiplier, closeTo(1.5, 1e-9));
    });
  });
}
