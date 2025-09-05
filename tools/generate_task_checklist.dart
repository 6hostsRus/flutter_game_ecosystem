// change-class: infra
// GenerateTaskChecklist: Scans platform/checklists/*.md and produces a visibility report.
// Outputs:
//  - docs/VISIBILITY.md (full breakdown)
//  - updates README marker <!-- AUTO:README_TASK_VISIBILITY -->
//  - writes build/metrics/task_checklist.json (summary for CI)
//  - writes docs/metrics/task_checklist.json (commit-friendly for dashboards)

import 'dart:convert';
import 'dart:io';

class SectionSummary {
  final String name;
  int open;
  int done;
  SectionSummary(this.name, {this.open = 0, this.done = 0});
  Map<String, dynamic> toJson() => {'name': name, 'open': open, 'done': done};
}

class FileSummary {
  final String file;
  final Map<String, SectionSummary> sections = {};
  int open = 0;
  int done = 0;
  // Labels used by dashboards/filters
  String platformLabel = 'both'; // ios | android | both
  String storeLabel = 'unified'; // app_store | play_store | unified
  FileSummary(this.file);
  Map<String, dynamic> toJson() => {
    'file': file,
    'open': open,
    'done': done,
    'labels': {'platform': platformLabel, 'store': storeLabel},
    'sections': sections.values.map((s) => s.toJson()).toList(),
  };
}

void main(List<String> args) {
  final root = Directory('platform/checklists');
  if (!root.existsSync()) {
    stderr.writeln('platform/checklists not found');
    exit(1);
  }

  final files =
      root
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.md'))
          // skip prompts and meta if desired? keep all .md except prompts.
          .where((f) => !f.path.endsWith('copilot_prompts.md'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final summaries = <FileSummary>[];
  // Aggregate platform counters
  final platformTotals = <String, Map<String, int>>{
    'ios': {'open': 0, 'done': 0},
    'android': {'open': 0, 'done': 0},
    'both': {'open': 0, 'done': 0},
  };
  for (final f in files) {
    final fs = FileSummary(f.path.split('/').last);
    // Derive default labels from filename
    if (fs.file.contains('app_store')) {
      fs.platformLabel = 'ios';
      fs.storeLabel = 'app_store';
    } else if (fs.file.contains('play_store')) {
      fs.platformLabel = 'android';
      fs.storeLabel = 'play_store';
    } else {
      fs.platformLabel = 'both';
      fs.storeLabel = 'unified';
    }
    String currentSection = 'General';
    fs.sections[currentSection] = SectionSummary(currentSection);
    String?
    currentPlatform; // overrides within sections, e.g., "iOS:" / "Android:"
    bool sectionImpliesBoth = false;
    for (final raw in f.readAsLinesSync()) {
      final line = raw.trimRight();
      // Sections: lines starting with one or more #'s but not just the title
      if (RegExp(r'^#{1,6}\s+').hasMatch(line)) {
        final name = line.replaceFirst(RegExp(r'^#{1,6}\s+'), '').trim();
        // avoid file title (first heading) by allowing resets freely
        currentSection = name;
        fs.sections.putIfAbsent(name, () => SectionSummary(name));
        // Reset per-section platform hints; mark if section indicates both
        currentPlatform = null;
        sectionImpliesBoth = RegExp(
          r'\(both\)',
          caseSensitive: false,
        ).hasMatch(name);
        continue;
      }
      // Platform bullets inside unified files (e.g., "- iOS:" / "- Android:")
      final platformBullet = RegExp(
        r'^\s*-\s*(iOS|Android)\s*:',
        caseSensitive: false,
      );
      final m = platformBullet.firstMatch(line);
      if (m != null) {
        final tag = m.group(1)!.toLowerCase();
        currentPlatform = tag == 'ios' ? 'ios' : 'android';
        continue;
      }
      // Task lines (allow leading whitespace)
      if (RegExp(r'^\s*-\s*\[ \]').hasMatch(line)) {
        fs.open++;
        fs.sections[currentSection]!.open++;
        final plat = _resolvePlatform(
          currentPlatform,
          fs.platformLabel,
          sectionImpliesBoth,
        );
        platformTotals[plat]!['open'] =
            (platformTotals[plat]!['open'] ?? 0) + 1;
      } else if (RegExp(r'^\s*-\s*\[[xX]\]').hasMatch(line)) {
        fs.done++;
        fs.sections[currentSection]!.done++;
        final plat = _resolvePlatform(
          currentPlatform,
          fs.platformLabel,
          sectionImpliesBoth,
        );
        platformTotals[plat]!['done'] =
            (platformTotals[plat]!['done'] ?? 0) + 1;
      }
    }
    summaries.add(fs);
  }

  // Write JSON summary
  final outDir = Directory('build/metrics')..createSync(recursive: true);
  final jsonFile = File('${outDir.path}/task_checklist.json');
  final totalOpen = summaries.fold<int>(0, (a, b) => a + b.open);
  final totalDone = summaries.fold<int>(0, (a, b) => a + b.done);
  final jsonData = {
    'generated': DateTime.now().toUtc().toIso8601String(),
    'totalOpen': totalOpen,
    'totalDone': totalDone,
    'platforms': platformTotals,
    'files': summaries.map((s) => s.toJson()).toList(),
  };
  jsonFile.writeAsStringSync(jsonEncode(jsonData));
  // Commit-friendly JSON copy for dashboards
  final docsMetricsDir = Directory('docs/metrics')..createSync(recursive: true);
  File(
    '${docsMetricsDir.path}/task_checklist.json',
  ).writeAsStringSync(jsonEncode(jsonData));

  // Build VISIBILITY.md
  final vis =
      StringBuffer()
        ..writeln('# Task Checklist Visibility')
        ..writeln()
        ..writeln('Generated: ${DateTime.now().toUtc().toIso8601String()}')
        ..writeln()
        ..writeln('Total open: $totalOpen, done: $totalDone')
        ..writeln()
        ..writeln('Platform breakdown:')
        ..writeln(
          '- iOS → open: ${platformTotals['ios']!['open']}, done: ${platformTotals['ios']!['done']}',
        )
        ..writeln(
          '- Android → open: ${platformTotals['android']!['open']}, done: ${platformTotals['android']!['done']}',
        )
        ..writeln(
          '- Both/Unscoped → open: ${platformTotals['both']!['open']}, done: ${platformTotals['both']!['done']}',
        )
        ..writeln();
  for (final s in summaries) {
    vis.writeln('## ${s.file}');
    vis.writeln('- Open: ${s.open}, Done: ${s.done}');
    vis.writeln('- Labels: platform=${s.platformLabel}, store=${s.storeLabel}');
    // Per-section breakdown (only sections with items)
    for (final sec in s.sections.values) {
      if (sec.open == 0 && sec.done == 0) continue;
      vis.writeln('  - ${sec.name}: ${sec.open} open, ${sec.done} done');
    }
    vis.writeln();
  }
  final visFile = File('docs/VISIBILITY.md');
  visFile.createSync(recursive: true);
  visFile.writeAsStringSync(vis.toString());

  // Update README marker
  final readme = File('README.md');
  if (readme.existsSync()) {
    String txt = readme.readAsStringSync();
    final summaryParts = summaries
        .map((s) => '${_basename(s.file)}: ${s.open}')
        .join(', ');
    final stamp = 'Open checklist items: $totalOpen (${summaryParts})';
    txt = _replaceMarker(txt, 'AUTO:README_TASK_VISIBILITY', stamp);
    readme.writeAsStringSync(txt);
  }

  stdout.writeln(
    'Generated task checklist: open=$totalOpen, files=${summaries.length}',
  );
}

String _basename(String path) {
  final idx = path.lastIndexOf('/');
  final file = idx == -1 ? path : path.substring(idx + 1);
  return file.replaceAll('.md', '');
}

String _replaceMarker(String text, String marker, String value) {
  final pattern = RegExp('<!-- $marker -->(.*?)<!-- END -->', dotAll: true);
  if (pattern.hasMatch(text)) {
    return text.replaceAllMapped(
      pattern,
      (m) => '<!-- $marker -->$value<!-- END -->',
    );
  }
  // If marker missing, append at end (before trailing backticks if present).
  return text.trimRight() + '\n\n<!-- $marker -->' + value + '<!-- END -->\n';
}

// Determine the effective platform for a task, based on local bullet override, file label, or section hint.
String _resolvePlatform(
  String? currentPlatform,
  String filePlatform,
  bool sectionImpliesBoth,
) {
  if (currentPlatform != null) return currentPlatform;
  if (sectionImpliesBoth) return 'both';
  return filePlatform; // ios | android | both
}
