import "package:collection/collection.dart";

Map<String, dynamic> diffMaps(
  Map<String, dynamic> before,
  Map<String, dynamic> after,
) {
  final out = <String, dynamic>{};
  final keys = <String>{...before.keys, ...after.keys};
  for (final k in keys) {
    final a = before[k];
    final b = after[k];
    if (a is Map && b is Map) {
      final child = diffMaps(
        Map<String, dynamic>.from(a),
        Map<String, dynamic>.from(b),
      );
      if (child.isNotEmpty) out[k] = child;
    } else if (!const DeepCollectionEquality().equals(a, b)) {
      out[k] = {"_old": a, "_new": b};
    }
  }
  return out;
}

Map<String, dynamic> deepMerge(List<Map<String, dynamic>> layers) {
  Map<String, dynamic> result = {};
  for (final layer in layers) {
    result = _mergeTwo(result, layer);
  }
  return result;
}

Map<String, dynamic> _mergeTwo(
  Map<String, dynamic> base,
  Map<String, dynamic> override,
) {
  final out = Map<String, dynamic>.from(base);
  override.forEach((key, value) {
    if (value is Map && base[key] is Map) {
      out[key] = _mergeTwo(
        Map<String, dynamic>.from(base[key]),
        Map<String, dynamic>.from(value),
      );
    } else {
      out[key] = value;
    }
  });
  return out;
}
