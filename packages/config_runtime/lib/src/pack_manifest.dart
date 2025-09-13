import "dart:convert";
import "dart:io";
import "package:meta/meta.dart";
import "package:yaml/yaml.dart";

@immutable
class PackManifest {
  final String name;
  final String engine;
  final String? discipline;
  final String? season;
  final List<String> tags;
  final bool lockSeed;
  final String? minAppVersion;
  final Map<String, dynamic>? compat;
  final Map<String, dynamic>? rollout;
  final List<String> locales;
  final bool requiresSubs;
  final String risk; // low|medium|high|experimental

  const PackManifest({
    required this.name,
    required this.engine,
    this.discipline,
    this.season,
    this.tags = const [],
    this.lockSeed = false,
    this.minAppVersion,
    this.compat,
    this.rollout,
    this.locales = const ["en"],
    this.requiresSubs = false,
    this.risk = "low",
  });

  static PackManifest fromYamlFile(String path) {
    final f = File(path);
    if (!f.existsSync()) {
      throw StateError("packs.index.yaml not found at $path");
    }
    final doc = loadYaml(f.readAsStringSync());
    if (doc is YamlMap &&
        doc["packs"] is YamlList &&
        (doc["packs"] as YamlList).isNotEmpty) {
      final first = (doc["packs"] as YamlList).first as YamlMap;
      return PackManifest.fromMap(Map<String, dynamic>.from(first));
    }
    throw StateError(
      "Invalid packs.index.yaml structure: expected top-level \"packs\" list",
    );
  }

  static PackManifest fromMap(Map<String, dynamic> m) {
    return PackManifest(
      name: m["name"]?.toString() ?? "unnamed",
      engine: m["engine"]?.toString() ?? "unknown",
      discipline: m["discipline"]?.toString(),
      season: m["season"]?.toString(),
      tags: (m["tags"] as List?)?.map((e) => e.toString()).toList() ?? const [],
      lockSeed: (m["lockSeed"] == true),
      minAppVersion: m["minAppVersion"]?.toString(),
      compat:
          (m["compat"] is Map) ? Map<String, dynamic>.from(m["compat"]) : null,
      rollout: (m["rollout"] is Map)
          ? Map<String, dynamic>.from(m["rollout"])
          : null,
      locales: (m["locales"] as List?)?.map((e) => e.toString()).toList() ??
          const ["en"],
      requiresSubs: (m["requiresSubs"] == true),
      risk: m["risk"]?.toString() ?? "low",
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "engine": engine,
        "discipline": discipline,
        "season": season,
        "tags": tags,
        "lockSeed": lockSeed,
        "minAppVersion": minAppVersion,
        "compat": compat,
        "rollout": rollout,
        "locales": locales,
        "requiresSubs": requiresSubs,
        "risk": risk,
      };

  @override
  String toString() => jsonEncode(toJson());
}
