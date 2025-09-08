import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';

void main() {
  test('defaults are true for all features', () {
    const cfg = AppConfig.defaults;
    expect(cfg.featureIdle, isTrue);
    expect(cfg.featurePlatformer, isTrue);
    expect(cfg.featureRpg, isTrue);
    expect(cfg.featureMatch, isTrue);
    expect(cfg.featureCcg, isTrue);
    expect(cfg.featureSurvivor, isTrue);
  });

  test('copyWith overrides selected flags', () {
    const cfg = AppConfig.defaults;
    final custom = cfg.copyWith(featureIdle: false, featureRpg: false);
    expect(custom.featureIdle, isFalse);
    expect(custom.featureRpg, isFalse);
    expect(custom.featurePlatformer, isTrue);
  });
}
