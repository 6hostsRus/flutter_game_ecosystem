// change-class: infra
// ConsolidateStackDocs: Generates a canonical, consolidated architecture view.
// Inputs:
//  - architecture/overview.md (legacy/partial)
//  - README_unified_stack.md (legacy guidance)
//  - docs/modules/*.md (module docs)
//  - packages/ tree (to list packages)
// Outputs:
//  - docs/STACK.md (overwrites, preserves optional custom section between markers)
//  - docs/metrics/stack_index.json (sources + headings index)

import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final now = DateTime.now().toUtc();

  final sources = <String, String>{};
  void readIfExists(String path) {
    final f = File(path);
    if (f.existsSync()) {
      sources[path] = f.readAsStringSync();
    }
  }

  // Load known sources
  readIfExists('architecture/overview.md');
  readIfExists('README_unified_stack.md');

  // Collect module docs
  final modulesDir = Directory('docs/modules');
  final moduleFiles = <File>[];
  if (modulesDir.existsSync()) {
    moduleFiles.addAll(modulesDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.md'))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path)));
    for (final f in moduleFiles) {
      sources[f.path] = f.readAsStringSync();
    }
  }

  // Parse headings for index
  Map<String, List<Map<String, dynamic>>> index = {};
  final headingRegex = RegExp(r'^(#{1,6})\s+(.*)');
  for (final entry in sources.entries) {
    final lines = entry.value.split('\n');
    final entries = <Map<String, dynamic>>[];
    for (final line in lines) {
      final m = headingRegex.firstMatch(line.trimRight());
      if (m != null) {
        entries.add({'level': m.group(1)!.length, 'title': m.group(2)!.trim()});
      }
    }
    index[entry.key] = entries;
  }

  // Build consolidated sections
  String extractSection(String content, String title) {
    // naive: find heading by exact match, return lines until next same or higher level
    final lines = content.split('\n');
    final out = StringBuffer();
    int? startLevel;
    bool inSec = false;
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final m = headingRegex.firstMatch(line);
      if (m != null) {
        final lvl = m.group(1)!.length;
        final ttl = m.group(2)!.trim();
        if (!inSec && ttl.toLowerCase() == title.toLowerCase()) {
          inSec = true;
          startLevel = lvl;
          continue; // skip the found heading; caller will add its own
        } else if (inSec && startLevel != null && lvl <= startLevel) {
          break;
        }
      }
      if (inSec) out.writeln(line);
    }
    return out.toString().trim();
  }

  String bulletsFromSection(String content, String title) {
    final sec = extractSection(content, title);
    if (sec.isEmpty) return '';
    // keep bullet lines only
    final lines = sec.split('\n');
    final bullets = lines.where((l) => l.trimLeft().startsWith('- ')).join('\n');
    return bullets.trim();
  }

  final overview = sources['architecture/overview.md'] ?? '';
  final unified = sources['README_unified_stack.md'] ?? '';

  // Sections
  final coreStackBullets = bulletsFromSection(overview, 'Stack');
  final riverpodPatterns = extractSection(unified, 'Riverpod Patterns');
  final folderShape = extractSection(unified, 'Folder Shape');
  final optionalAddons = extractSection(unified, 'Optional Add-ons');

  // Modules listing
  String modulesIndex() {
    if (moduleFiles.isEmpty) return '_No module docs found._\n';
    final buf = StringBuffer();
    for (final f in moduleFiles) {
      final name = f.uri.pathSegments.last.replaceAll('.md', '');
      final title = _firstHeading(sources[f.path]!);
      // docs/STACK.md → docs/modules/<file>.md
      buf.writeln('- [$title](modules/${name}.md)');
    }
    return buf.toString();
  }

  // Packages list from repo tree
  String packagesIndex() {
    final dir = Directory('packages');
    if (!dir.existsSync()) return '_No packages directory._\n';
    final entries = dir
        .listSync()
        .whereType<Directory>()
        .map((d) => d.uri.pathSegments.last.replaceAll('/', ''))
        .toList()
      ..sort();
    if (entries.isEmpty) return '_No packages._\n';
    return entries.map((e) => '- $e').join('\n') + '\n';
  }

  // Custom preserved section markers
  final customStart = '<!-- CUSTOM:STACK_NOTES -->';
  final customEnd = '<!-- END CUSTOM -->';
  final stackFile = File('docs/STACK.md');
  String preservedCustom = '';
  if (stackFile.existsSync()) {
    final txt = stackFile.readAsStringSync();
    final rx = RegExp('$customStart(.*?)$customEnd', dotAll: true);
    final m = rx.firstMatch(txt);
    if (m != null) preservedCustom = m.group(1)!.trim();
  }

  final out = StringBuffer()
    ..writeln('# Stack Overview')
    ..writeln()
    ..writeln('> Canonical consolidated architecture + stack reference. (Generated ${now.toIso8601String()})')
    ..writeln()
    ..writeln('## Core Stack')
    ..writeln()
    ..writeln(coreStackBullets.isNotEmpty
        ? coreStackBullets
        : '- Flutter UI + GoRouter for navigation\n- Riverpod for DI/state (ProviderScope root)\n- Analytics adapter layer with pluggable sinks\n- Isar/Drift persistence options')
    ..writeln()
    ..writeln('## Package Topology')
    ..writeln()
  ..writeln('```')
  ..writeln('packages/')
  ..writeln('  (auto-detected)')
  ..writeln('```')
    ..writeln(packagesIndex())
    ..writeln('## Modules Index')
    ..writeln()
    ..writeln(modulesIndex())
    ..writeln('## Design Principles')
    ..writeln()
    ..writeln('- Ports & Adapters with clean boundaries')
    ..writeln('- Data-driven definitions (levels/items)')
    ..writeln('- Deterministic core (injectable clock/RNG)')
    ..writeln('- Minimal singletons; prefer provider scope')
    ..writeln()
    ..writeln('## Riverpod Patterns')
    ..writeln()
    ..writeln(riverpodPatterns.isNotEmpty ? riverpodPatterns : '_See README_unified_stack.md_')
    ..writeln()
    ..writeln('## Folder Shape')
    ..writeln()
    ..writeln((){
      if (folderShape.isEmpty) return '_See README_unified_stack.md_';
      final b = StringBuffer();
      b.writeln('```');
      b.writeln(folderShape.trim());
      b.writeln('```');
      return b.toString();
    }())
    ..writeln()
    ..writeln('## Optional Add-ons')
    ..writeln()
    ..writeln(optionalAddons.isNotEmpty ? optionalAddons : '_See README_unified_stack.md_')
    ..writeln()
    ..writeln('## Custom Notes')
    ..writeln(customStart)
    ..writeln(preservedCustom.isNotEmpty ? preservedCustom : '\n_Add any team-specific architecture notes here._\n')
    ..writeln(customEnd)
    ..writeln()
    ..writeln('## Deprecation Notes')
    ..writeln()
    ..writeln('Supersedes overlapping sections in `architecture/overview.md` and `README_unified_stack.md`.');

  // Write out
  stackFile.createSync(recursive: true);
  stackFile.writeAsStringSync(out.toString());

  // Write index JSON
  final metricsDir = Directory('docs/metrics')..createSync(recursive: true);
  final idxFile = File('${metricsDir.path}/stack_index.json');
  idxFile.writeAsStringSync(jsonEncode({
    'generated': now.toIso8601String(),
    'sources': index,
  }));

  // Optional: update README marker
  final readme = File('README.md');
  if (readme.existsSync()) {
    final stamp = 'Stack consolidated: ${now.toIso8601String()}';
    final txt = _replaceMarker(readme.readAsStringSync(), 'AUTO:README_STACK_GEN', stamp);
    readme.writeAsStringSync(txt);
  }

  stdout.writeln('Consolidated stack docs → docs/STACK.md');
}

String _firstHeading(String md) {
  final m = RegExp(r'^#\s+(.*)', multiLine: true).firstMatch(md);
  return m != null ? m.group(1)!.trim() : 'Untitled';
}

String _replaceMarker(String text, String marker, String value) {
  final pattern = RegExp('<!-- $marker -->(.*?)<!-- END -->', dotAll: true);
  if (pattern.hasMatch(text)) {
    return text.replaceAllMapped(
        pattern, (m) => '<!-- $marker -->$value<!-- END -->');
  }
  return text.trimRight() + '\n\n<!-- $marker -->' + value + '<!-- END -->\n';
}
