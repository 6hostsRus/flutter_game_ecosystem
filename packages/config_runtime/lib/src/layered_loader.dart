import "dart:convert";
import "dart:io";
import "package:yaml/yaml.dart";
import "package:path/path.dart" as p;
import "csv_shard_decoder.dart";
import "merge_diff.dart";
import "models.dart";
import "pack_manifest.dart";

class LayeredLoader {
  final String configRoot; // e.g. examples/configurator/config
  final String selectedPack;
  final String? deviceId;
  final List<String> envFlags; // e.g. ["experiments", "low_end"]

  LayeredLoader({
    required this.configRoot,
    required this.selectedPack,
    this.deviceId,
    this.envFlags = const [],
  });

  MergedConfig load() {
    final errors = <String>[];
    final warnings = <String>[];
    final rawLayers = <String, dynamic>{};

    // 1) defaults
    final defaultsDir = p.join(configRoot, "defaults");
    final defaults = _readAllYamlJson(defaultsDir);
    rawLayers["defaults"] = defaults;

    // 2) pack
    final packDir = p.join(configRoot, "packs", selectedPack);
    if (!Directory(packDir).existsSync()) {
      errors.add("Pack \"$selectedPack\" not found under $packDir");
    }
    final pack = _readAllYamlJson(packDir);
    rawLayers["pack"] = pack;

    // csv shards (from pack root)
    final csvShards = loadCsvShards(packDir);

    // 3) env flags
    final envLayers = <Map<String, dynamic>>[];
    for (final flag in envFlags) {
      final envPathGlobal = p.join(configRoot, "env", "$flag.yaml");
      final envPathPack = p.join(packDir, "env", "$flag.yaml");
      final globalLayer = _readIfExists(envPathGlobal);
      final packLayer = _readIfExists(envPathPack);
      if (globalLayer != null) envLayers.add(globalLayer);
      if (packLayer != null) envLayers.add(packLayer);
    }
    final envMerged = deepMerge(envLayers);
    rawLayers["env"] = envMerged;

    // 4) device overrides
    Map<String, dynamic> device = {};
    if (deviceId != null && deviceId!.isNotEmpty) {
      final devPath = p.join(
        configRoot,
        "overrides",
        "devices",
        "$deviceId.yaml",
      );
      device = _readIfExists(devPath) ?? {};
    }
    rawLayers["device"] = device;

    // 5) dev/local overrides (gitignored)
    final localDir = p.join(configRoot, "overrides", "local");
    final local = _readAllYamlJson(localDir);
    rawLayers["local"] = local;

    // Merge in canonical order:
    final effective = deepMerge([defaults, pack, envMerged, device, local]);

    // Diff (defaults -> effective) for quick view
    final diffTree = diffMaps(defaults, effective);

    // Pull manifest (first entry from packs.index.yaml)
    final manifestPath = p.join(configRoot, "packs.index.yaml");
    final manifest = File(manifestPath).existsSync()
        ? PackManifest.fromYamlFile(manifestPath)
        : PackManifest(
            name: selectedPack,
            engine: effective["engine"]?.toString() ?? "unknown",
          );

    if (manifest.minAppVersion != null) {
      warnings.add(
        "minAppVersion present (${manifest.minAppVersion}) – not evaluated here.",
      );
    }

    return MergedConfig(
      effective: effective,
      diffTree: diffTree,
      manifest: manifest,
      csvShards: csvShards,
      errors: errors,
      warnings: warnings,
      rawLayers: rawLayers,
    );
  }

  Map<String, dynamic> _readAllYamlJson(String dir) {
    final root = Directory(dir);
    if (!root.existsSync()) return <String, dynamic>{};
    final maps = <Map<String, dynamic>>[];
    for (final f in root.listSync(recursive: true).whereType<File>()) {
      final lower = f.path.toLowerCase();
      if (lower.endsWith(".yaml") || lower.endsWith(".yml")) {
        maps.add(_yamlToMap(f.readAsStringSync()));
      } else if (lower.endsWith(".json")) {
        final decoded = json.decode(f.readAsStringSync());
        if (decoded is Map<String, dynamic>) {
          maps.add(decoded);
        }
      }
    }
    return deepMerge(maps);
  }

  Map<String, dynamic>? _readIfExists(String file) {
    final f = File(file);
    if (!f.existsSync()) return null;
    final lower = file.toLowerCase();
    if (lower.endsWith(".yaml") || lower.endsWith(".yml")) {
      return _yamlToMap(f.readAsStringSync());
    } else if (lower.endsWith(".json")) {
      final decoded = json.decode(f.readAsStringSync());
      if (decoded is Map<String, dynamic>) return decoded;
    }
    return null;
  }

  Map<String, dynamic> _yamlToMap(String src) {
    final doc = loadYaml(src);
    if (doc is YamlMap) {
      return Map<String, dynamic>.from(doc);
    }
    return <String, dynamic>{};
  }
}
