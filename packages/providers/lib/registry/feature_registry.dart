library providers.feature_registry;

import 'dart:async';

class NavEntry {
  final String id;
  final String iconKey;
  final String label;
  final String? badgeKey;
  const NavEntry(
      {required this.id,
      required this.iconKey,
      required this.label,
      this.badgeKey});
}

class Feature {
  final String id;
  final String title;
  final List<NavEntry> nav;
  final Map<String, Object?> meta;
  const Feature(
      {required this.id,
      required this.title,
      required this.nav,
      this.meta = const {}});
}

abstract class FeatureRegistry {
  List<Feature> list();
  Stream<List<Feature>> watch();
}

class MutableFeatureRegistry implements FeatureRegistry {
  final List<Feature> _features = [];
  final _ctrl = StreamController<List<Feature>>.broadcast();

  @override
  List<Feature> list() => List.unmodifiable(_features);

  @override
  Stream<List<Feature>> watch() => _ctrl.stream;

  void upsert(Feature feature) {
    final idx = _features.indexWhere((f) => f.id == feature.id);
    if (idx >= 0) {
      _features[idx] = feature;
    } else {
      _features.add(feature);
    }
    _ctrl.add(list());
  }

  void remove(String id) {
    _features.removeWhere((f) => f.id == id);
    _ctrl.add(list());
  }

  void dispose() {
    _ctrl.close();
  }
}
