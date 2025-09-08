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

    test('tick advances time and waves', () {
      const s = SurvivorRunState(timeSec: 0, wave: 0, health: 100);
      final s2 = s.tick(31.0);
      expect(s2.timeSec, closeTo(31.0, 1e-9));
      expect(s2.wave, greaterThanOrEqualTo(1));
    });

    test('tick applies damage and death', () {
      const s =
          SurvivorRunState(timeSec: 0, wave: 0, damagePerSec: 10, health: 5);
      final s2 = s.tick(1.0);
      expect(s2.health, equals(0));
      expect(s2.isDead, isTrue);
    });

    test('effectiveDps scales with waves', () {
      const s =
          SurvivorRunState(damagePerSec: 2, dpsGrowthPerWave: 0.5, wave: 3);
      expect(s.effectiveDps, closeTo(2 * (1 + 3 * 0.5), 1e-9));
    });

    test('toJson/fromJson round trip and difficulty scaling', () {
      const s = SurvivorRunState(
        wave: 3,
        timeSec: 45.5,
        damagePerSec: 1.2,
        health: 77,
        dpsGrowthPerWave: 0.1,
        spawnGrowthPerWave: 0.05,
      );
      final j = s.toJson();
      final s2 = SurvivorRunState.fromJson(Map<String, Object?>.from(j));
      expect(s2.wave, s.wave);
      expect(s2.timeSec, closeTo(s.timeSec, 1e-9));
      expect(s2.damagePerSec, closeTo(s.damagePerSec, 1e-9));
      expect(s2.health, closeTo(s.health, 1e-9));
      expect(s2.dpsGrowthPerWave, closeTo(s.dpsGrowthPerWave, 1e-9));
      expect(s2.spawnGrowthPerWave, closeTo(s.spawnGrowthPerWave, 1e-9));

      var s3 = const SurvivorRunState(
        damagePerSec: 10,
        dpsGrowthPerWave: 0.2,
        spawnGrowthPerWave: 0.5,
      );
      expect(s3.effectiveDps, closeTo(10, 1e-9));
      expect(s3.spawnRateMultiplier, closeTo(1, 1e-9));
      s3 = s3.tick(30);
      expect(s3.wave, 1);
      expect(s3.effectiveDps, closeTo(12, 1e-9));
      expect(s3.spawnRateMultiplier, closeTo(1.5, 1e-9));
    });
  });
}
