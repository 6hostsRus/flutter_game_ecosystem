// A tiny utility to stamp 'Updated:' and 'Generated:' lines with today's date.
// Usage:
//   dart run tools/stamp_doc_dates.dart
// Options via env:
//   DOC_DATE=YYYY-MM-DD dart run tools/stamp_doc_dates.dart  # override date (useful for tests/CI)
// Scans *.md files and replaces leading lines like:
//   Updated: 2025-09-06 -> Updated: <today>
//   Generated: 2025-09-06 -> Generated: <today>

import 'dart:io';

void main(List<String> args) {
  final override = Platform.environment['DOC_DATE'];
  final today = override ?? _formatDate(DateTime.now().toUtc());

  final root = Directory.current;
  final changed = <String>[];

  for (final file in _listMarkdownFiles(root)) {
    final original = file.readAsStringSync();
    final updated = _stampContent(original, today);
    if (updated != null && updated != original) {
      file.writeAsStringSync(updated);
      changed.add(file.path);
    }
  }

  if (changed.isEmpty) {
    stdout.writeln('stamp_doc_dates: No changes needed.');
  } else {
    stdout.writeln('stamp_doc_dates: Updated ${changed.length} file(s):');
    for (final p in changed) {
      stdout.writeln(' - $p');
    }
  }
}

String _formatDate(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

Iterable<File> _listMarkdownFiles(Directory root) sync* {
  final ignoreDirs = <String>{
    '.git',
    '.dart_tool',
    'build',
    '.github', // workflows rarely need stamping; keeps PR noise low
    'android',
    'ios',
    'linux',
    'macos',
    'windows',
    'web',
  };
  for (final ent in root.listSync(recursive: true, followLinks: false)) {
    if (ent is File && ent.path.toLowerCase().endsWith('.md')) {
      final parts = ent.uri.pathSegments;
      if (parts.any((seg) => ignoreDirs.contains(seg))) continue;
      yield ent;
    }
  }
}

String? _stampContent(String content, String today) {
  var mutated = false;
  final updatedRe = RegExp(
    r'^(\s*Updated:\s*)\d{4}-\d{2}-\d{2}',
    multiLine: true,
  );
  final generatedRe = RegExp(
    r'^(\s*Generated:\s*)\d{4}-\d{2}-\d{2}',
    multiLine: true,
  );

  String replaceDates(String input) {
    return input
        .replaceAllMapped(updatedRe, (m) {
          mutated = true;
          return '${m.group(1)}$today';
        })
        .replaceAllMapped(generatedRe, (m) {
          mutated = true;
          return '${m.group(1)}$today';
        });
  }

  final newContent = replaceDates(content);
  if (!mutated) return null;
  return newContent;
}
