
class AppConfig {
  static const bool featureIdle = bool.fromEnvironment('FEATURE_IDLE', defaultValue: true);
  static const bool featurePlatformer = bool.fromEnvironment('FEATURE_PLATFORMER', defaultValue: true);
  static const bool featureRpg = bool.fromEnvironment('FEATURE_RPG', defaultValue: true);
  static const bool featureMatch = bool.fromEnvironment('FEATURE_MATCH', defaultValue: true);
  static const bool featureCCG = bool.fromEnvironment('FEATURE_CCG', defaultValue: true);
  static const bool featureSurvivor = bool.fromEnvironment('FEATURE_SURVIVOR', defaultValue: true);
}
