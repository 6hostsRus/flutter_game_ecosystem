// change-class: infra
// ManifestDriftWatcher: wraps check_manifest.dart and prints add suggestions.
import 'dart:io';

void main(List<String> args) {
  final proc = Process.runSync('dart', ['run', 'tools/check_manifest.dart']);
  stdout.write(proc.stdout);
  stderr.write(proc.stderr);
  if (proc.exitCode == 0) return;
  final missing = <String>[];
  bool inMissing = false;
  for (final raw in (proc.stderr as String).split('\n')) {
    final line = raw.trim();
    if (line.startsWith('Missing entries for:')) {
      inMissing = true;
      continue;
    }
    if (line.startsWith('Stale manifest paths:')) {
      inMissing = false;
      continue;
    }
    if (line.startsWith('- ')) {
      final path = line.substring(2).trim();
      if (inMissing && path.isNotEmpty) missing.add(path);
    }
  }
  if (missing.isNotEmpty) {
    stdout.writeln('\nSuggested manifest additions:');
    for (final m in missing) {
      final key = m.split('/').last.replaceAll('-', '_');
      stdout.writeln(
        '''$key:\n     path: $m\n     role: TBD\n     status: experimental\n     owner: TBD\n     domain: TBD\n     notes: ''\n''',
      );
    }
  }
  exit(proc.exitCode);
}
