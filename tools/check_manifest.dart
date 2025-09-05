// Validates manifest.yaml contains entries for every package dir and no stale entries.
import 'dart:io';

void main() {
  final manifestFile = File('packages/manifest.yaml');
  if (!manifestFile.existsSync()) {
    stderr.writeln('Manifest missing: packages/manifest.yaml');
    exit(1);
  }
  final manifest = _parseYamlLike(manifestFile.readAsLinesSync());
  final pkgs = manifest['packages'];
  if (pkgs is! Map) {
    stderr.writeln('Malformed manifest: packages key missing or not a map');
    exit(1);
  }
  // Collect declared paths.
  final declared = <String, Map<String, dynamic>>{};
  pkgs.forEach((k, v) {
    if (v is Map && v['path'] is String) {
      declared[v['path'] as String] = {'key': k, ...v};
    }
  });
  // Discover actual package directories containing pubspec.yaml.
  final discovered = <String>{};
  final ignoreFile = File('packages/manifest_ignore.txt');
  final ignores = <String>[];
  if (ignoreFile.existsSync()) {
    for (final l in ignoreFile.readAsLinesSync()) {
      final t = l.trim();
      if (t.isEmpty || t.startsWith('#')) continue;
      ignores.add(t);
    }
  }
  void scanDir(String root) {
    final dir = Directory(root);
    if (!dir.existsSync()) return;
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('/pubspec.yaml')) {
        final p = entity.path;
        if (p.contains('/.plugin_symlinks/') ||
            p.contains('/build/') ||
            p.contains('/.dart_tool/'))
          continue;
        final path = p.substring(0, p.length - '/pubspec.yaml'.length);
        // Normalize relative path from repo root.
        final rel = path.replaceAll('\\', '/');
        // Skip root pubspec (monorepo root) if encountered.
        if (rel == '.' || rel.isEmpty) continue;
        final ignored = ignores.any((p) => rel.startsWith(p));
        if (!ignored) discovered.add(rel);
      }
    }
  }

  scanDir('packages');
  scanDir('examples');
  // Include additional roots for engine/content/tools packages.
  scanDir('game_core');
  scanDir('modules');
  scanDir('tools');
  final discoveredList = discovered.toList()..sort();

  final missing = <String>[];
  for (final d in discoveredList) {
    if (!declared.containsKey(d)) missing.add(d);
  }
  final stale = <String>[];
  for (final declPath in declared.keys) {
    if (!discovered.contains(declPath)) {
      stale.add(declPath);
    }
  }

  if (missing.isEmpty && stale.isEmpty) {
    // Logging: prefer stderr for tooling neutrality (avoid_print lint enforced).
    stderr.writeln('Manifest OK (${discovered.length} packages)');
    return;
  }
  stderr.writeln('Manifest drift detected:');
  if (missing.isNotEmpty) {
    stderr.writeln('  Missing entries for:');
    for (final m in missing) {
      stderr.writeln('    - $m');
    }
  }
  if (stale.isNotEmpty) {
    stderr.writeln('  Stale manifest paths:');
    for (final s in stale) {
      stderr.writeln('    - $s');
    }
  }
  exit(2);
}

// Very small YAML subset parser (indent-based) sufficient for our manifest style.
Map<String, dynamic> _parseYamlLike(List<String> lines) {
  final root = <String, dynamic>{};
  final stack = <_YamlCtx>[_YamlCtx(-1, root)];
  for (var raw in lines) {
    if (raw.trim().isEmpty || raw.trim().startsWith('#')) continue;
    final indent = raw.length - raw.trimLeft().length;
    while (stack.isNotEmpty && indent <= stack.last.indent) {
      stack.removeLast();
    }
    final ctx = stack.last.map;
    final line = raw.trim();
    if (line.endsWith(':')) {
      final key = line.substring(0, line.length - 1).trim();
      final newMap = <String, dynamic>{};
      ctx[key] = newMap;
      stack.add(_YamlCtx(indent, newMap));
    } else if (line.contains(':')) {
      final idx = line.indexOf(':');
      final key = line.substring(0, idx).trim();
      final value = line.substring(idx + 1).trim();
      ctx[key] = value.replaceAll("'", '').replaceAll('"', '');
    }
  }
  return root;
}

class _YamlCtx {
  final int indent;
  final Map<String, dynamic> map;
  _YamlCtx(this.indent, this.map);
}
