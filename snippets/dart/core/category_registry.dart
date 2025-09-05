import 'app_config.dart';

typedef CategoryBuilder = Object Function();

class CategoryDescriptor {
  final String id;
  final String title;
  final bool enabled;
  final CategoryBuilder? builder;
  const CategoryDescriptor({
    required this.id,
    required this.title,
    required this.enabled,
    this.builder,
  });
}

class CategoryRegistry {
  static final List<CategoryDescriptor> all = [
    const CategoryDescriptor(
      id: 'idle',
      title: 'Idle',
      enabled: AppConfig.featureIdle,
    ),
    const CategoryDescriptor(
      id: 'platformer',
      title: 'Platformer',
      enabled: AppConfig.featurePlatformer,
    ),
    const CategoryDescriptor(
      id: 'rpg',
      title: 'RPG',
      enabled: AppConfig.featureRpg,
    ),
    const CategoryDescriptor(
      id: 'match',
      title: 'Match',
      enabled: AppConfig.featureMatch,
    ),
    const CategoryDescriptor(
      id: 'ccg',
      title: 'Card Battle',
      enabled: AppConfig.featureCCG,
    ),
    const CategoryDescriptor(
      id: 'survivor',
      title: 'Survivor',
      enabled: AppConfig.featureSurvivor,
    ),
  ];
  static Iterable<CategoryDescriptor> enabled() => all.where((c) => c.enabled);
}
