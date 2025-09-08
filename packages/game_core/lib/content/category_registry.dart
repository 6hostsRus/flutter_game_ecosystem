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
  final List<CategoryDescriptor> all;
  const CategoryRegistry(this.all);

  Iterable<CategoryDescriptor> enabled() => all.where((c) => c.enabled);
}
