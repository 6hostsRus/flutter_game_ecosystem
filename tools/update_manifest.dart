// change-class: infra
// update_manifest.dart
// Discovers pubspec.yaml under packages/* and selected examples/* and ensures
// each has an entry in packages/manifest.yaml. Preserves existing entries and
// custom fields, adds missing ones with guessed metadata, and sorts keys.

import 'dart:io';

void main(List<String> args) {
  final manifestFile = File('packages/manifest.yaml');
  if (!manifestFile.existsSync()) {
    stderr.writeln('packages/manifest.yaml not found');
    exit(1);
  }
  final candidates = <String, String>{}; // key -> path

  void scanDir(Directory dir) {
    for (final e in dir.listSync(recursive: false)) {
      if (e is Directory) {
        final pubspec = File('${e.path}/pubspec.yaml');
        if (pubspec.existsSync()) {
          final key = e.uri.pathSegments.last.replaceAll('/', '');
          candidates[key] = e.path;
        }
      }
    }
  }

  final pkgsDir = Directory('packages');
  if (pkgsDir.existsSync()) scanDir(pkgsDir);
  final examplesDir = Directory('examples');
  if (examplesDir.existsSync()) {
    for (final e in examplesDir.listSync()) {
      if (e is Directory) scanDir(e);
    }
  }

  final lines = manifestFile.readAsLinesSync();
  final existingKeys = <String>{};
  for (final l in lines) {
    final m = RegExp(r'^\s{5}([A-Za-z0-9_\-]+):\s*\$').firstMatch(l);
    if (m != null) existingKeys.add(m.group(1)!);
  }

  final missing = <String, String>{};
  candidates.forEach((k, p) {
    if (!existingKeys.contains(k)) missing[k] = p;
  });

  if (missing.isEmpty) {
    stdout.writeln('Manifest up to date (no missing packages).');
    return;
  }

  // Prepare insertion text after 'packages:' line.
  final insertBlocks = <String>[];
  final today = DateTime.now().toUtc().toIso8601String().split('T').first;
  final sortedKeys = missing.keys.toList()..sort();
  for (final k in sortedKeys) {
    final path = missing[k]!;
    final role = _guessRoleFromPath(path);
    final domain = _guessDomainFromPath(path);
    insertBlocks.add('''     $k:
          path: $path
          role: $role
          status: experimental
          since: '$today'
          owner: core
          domain: $domain
          notes: ''
''');
  }

  // Write updated manifest by appending new keys before end of file.
  final content = StringBuffer();
  bool bumpedDate = false;
  for (final l in lines) {
    if (l.trim().startsWith('last_updated:')) {
      content.writeln("last_updated: '$today'");
      bumpedDate = true;
      continue;
    }
    content.writeln(l);
  }
  if (!bumpedDate) content.writeln("last_updated: '$today'");
  content.writeAll(insertBlocks);
  manifestFile.writeAsStringSync(content.toString());
  stdout.writeln('Added ${missing.length} missing package(s) to manifest.');
}

String _guessRoleFromPath(String p) {
  if (p.contains('/analytics')) return 'plugin';
  if (p.contains('/core_services')) return 'core_services';
  if (p.contains('/providers')) return 'support';
  if (p.contains('/ui_shell')) return 'ui';
  if (p.contains('/examples/')) return 'example';
  if (p.contains('/tools/')) return 'tool';
  return 'library';
}

String _guessDomainFromPath(String p) {
  if (p.contains('analytics')) return 'analytics';
  if (p.contains('monetization') || p.contains('purchase'))
    return 'monetization';
  if (p.contains('core_services')) return 'infra';
  if (p.contains('ui')) return 'interface';
  return 'misc';
}
