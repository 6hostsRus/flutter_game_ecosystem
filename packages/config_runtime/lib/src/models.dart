import "dart:convert";
import "pack_manifest.dart";

class MergedConfig {
  final Map<String, dynamic> effective;
  final Map<String, dynamic> diffTree;
  final PackManifest manifest;
  final Map<String, List<Map<String, dynamic>>> csvShards;
  final List<String> errors;
  final List<String> warnings;
  final Map<String, dynamic> rawLayers;

  MergedConfig({
    required this.effective,
    required this.diffTree,
    required this.manifest,
    required this.csvShards,
    required this.errors,
    required this.warnings,
    required this.rawLayers,
  });

  String toPrettyJson([Object? data]) =>
      const JsonEncoder.withIndent("  ").convert(data ?? effective);
}
