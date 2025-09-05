import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:yaml/yaml.dart';
import 'package:json_schema2/json_schema2.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('schema-dir', defaultsTo: 'templates/schemas')
    ..addOption('input-dir', defaultsTo: 'modules/content_packs/winter_2025');

  final results = parser.parse(args);
  final schemaDir = results['schema-dir'];
  final inputDir = results['input-dir'];

  final schemas = {
    'manifest': await _loadSchema('$schemaDir/manifest.schema.json'),
    'economy': await _loadSchema('$schemaDir/economy.schema.json'),
    'quests': await _loadSchema('$schemaDir/quests.schema.json'),
    'scenes': await _loadSchema('$schemaDir/scenes.schema.json'),
  };

  final manifestFile = File('$inputDir/manifest.yaml');
  final manifest = loadYaml(await manifestFile.readAsString());
  _validate(
      schemas['manifest']!, jsonDecode(jsonEncode(manifest)), 'manifest.yaml');

  final economyFile = File('$inputDir/economy.json');
  final economy = jsonDecode(await economyFile.readAsString());
  _validate(schemas['economy']!, economy, 'economy.json');

  final questsFile = File('$inputDir/quests.json');
  final quests = jsonDecode(await questsFile.readAsString());
  _validate(schemas['quests']!, quests, 'quests.json');

  final scenesFile = File('$inputDir/scenes.yaml');
  final scenes = loadYaml(await scenesFile.readAsString());
  _validate(schemas['scenes']!, jsonDecode(jsonEncode(scenes)), 'scenes.yaml');

  // Use stderr to keep consistent with tooling scripts and satisfy avoid_print.
  stderr.writeln('All files validated successfully.');
}

Future<JsonSchema> _loadSchema(String path) async {
  final txt = await File(path).readAsString();
  final data = jsonDecode(txt);
  return JsonSchema.createSchema(data);
}

void _validate(JsonSchema schema, Object? data, String filename) {
  final result = schema.validateWithErrors(data);
  if (result.isNotEmpty) {
    stderr.writeln('Validation errors in $filename:');
    for (final err in result) {
      stderr.writeln(' - ${err.message} at ${err.instancePath}');
    }
    exit(1);
  }
}
