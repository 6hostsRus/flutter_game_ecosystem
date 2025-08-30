
import 'app_config.dart';
typedef CategoryBuilder = Object Function();
class CategoryDescriptor {
  final String id; final String title; final bool enabled; final CategoryBuilder? builder;
  const CategoryDescriptor({required this.id, required this.title, required this.enabled, this.builder});
}
class CategoryRegistry {
  static final List<CategoryDescriptor> all = [
    CategoryDescriptor(id:'idle', title:'Idle', enabled:AppConfig.featureIdle),
    CategoryDescriptor(id:'platformer', title:'Platformer', enabled:AppConfig.featurePlatformer),
    CategoryDescriptor(id:'rpg', title:'RPG', enabled:AppConfig.featureRpg),
    CategoryDescriptor(id:'match', title:'Match', enabled:AppConfig.featureMatch),
    CategoryDescriptor(id:'ccg', title:'Card Battle', enabled:AppConfig.featureCCG),
    CategoryDescriptor(id:'survivor', title:'Survivor', enabled:AppConfig.featureSurvivor),
  ];
  static Iterable<CategoryDescriptor> enabled()=>all.where((c)=>c.enabled);
}
