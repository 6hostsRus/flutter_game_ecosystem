/// App-wide feature flags and configuration.
///
/// Usage:
/// - At runtime, construct `const AppConfig.defaults` or provide overrides via
///   `copyWith`.
/// - To read compile-time defines (e.g., --dart-define=FEATURE_IDLE=false), use
///   `AppConfig.fromEnvironment()` which uses const `bool.fromEnvironment`.
class AppConfig {
  final bool featureIdle;
  final bool featurePlatformer;
  final bool featureRpg;
  final bool featureMatch;
  final bool featureCcg;
  final bool featureSurvivor;

  const AppConfig({
    this.featureIdle = true,
    this.featurePlatformer = true,
    this.featureRpg = true,
    this.featureMatch = true,
    this.featureCcg = true,
    this.featureSurvivor = true,
  });

  static const defaults = AppConfig();

  /// Construct from compile-time environment defines.
  /// If no defines are provided, defaults to `true` for all features.
  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      featureIdle: _kFeatureIdle,
      featurePlatformer: _kFeaturePlatformer,
      featureRpg: _kFeatureRpg,
      featureMatch: _kFeatureMatch,
      featureCcg: _kFeatureCcg,
      featureSurvivor: _kFeatureSurvivor,
    );
  }

  AppConfig copyWith({
    bool? featureIdle,
    bool? featurePlatformer,
    bool? featureRpg,
    bool? featureMatch,
    bool? featureCcg,
    bool? featureSurvivor,
  }) {
    return AppConfig(
      featureIdle: featureIdle ?? this.featureIdle,
      featurePlatformer: featurePlatformer ?? this.featurePlatformer,
      featureRpg: featureRpg ?? this.featureRpg,
      featureMatch: featureMatch ?? this.featureMatch,
      featureCcg: featureCcg ?? this.featureCcg,
      featureSurvivor: featureSurvivor ?? this.featureSurvivor,
    );
  }

  @override
  String toString() {
    return 'AppConfig('
        'idle: '
        '$featureIdle, '
        'platformer: '
        '$featurePlatformer, '
        'rpg: '
        '$featureRpg, '
        'match: '
        '$featureMatch, '
        'ccg: '
        '$featureCcg, '
        'survivor: '
        '$featureSurvivor)';
  }
}

// Compile-time environment reads. These are const so tree-shaking can prune
// unreachable code paths in release builds when desired.
const bool _kFeatureIdle =
    bool.fromEnvironment('FEATURE_IDLE', defaultValue: true);
const bool _kFeaturePlatformer =
    bool.fromEnvironment('FEATURE_PLATFORMER', defaultValue: true);
const bool _kFeatureRpg =
    bool.fromEnvironment('FEATURE_RPG', defaultValue: true);
const bool _kFeatureMatch =
    bool.fromEnvironment('FEATURE_MATCH', defaultValue: true);
const bool _kFeatureCcg =
    bool.fromEnvironment('FEATURE_CCG', defaultValue: true);
const bool _kFeatureSurvivor =
    bool.fromEnvironment('FEATURE_SURVIVOR', defaultValue: true);
