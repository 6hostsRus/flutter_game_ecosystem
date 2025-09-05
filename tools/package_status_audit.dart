// change-class: infra
// Audits package status ages: warns if status=experimental beyond threshold days.
// Threshold configurable via EXPERIMENTAL_MAX_DAYS (default 60).
// Exits 0 unless STRICT_PACKAGE_STATUS=1 -> exits 2 on violations.
import 'dart:io';

void main() {
  final file = File('packages/manifest.yaml');
  if (!file.existsSync()) {
    stderr.writeln('manifest.yaml missing');
    exit(0);
  }
  final lines = file.readAsLinesSync();
  final maxDays =
      int.tryParse(Platform.environment['EXPERIMENTAL_MAX_DAYS'] ?? '') ?? 60;
  final strict = Platform.environment['STRICT_PACKAGE_STATUS'] == '1';
  final now = DateTime.now().toUtc();
  final violations = <String>[]; // package messages
  String? currentPkg;
  DateTime? pkgSince;
  String? status;
  for (final raw in lines) {
    final trimmed = raw.trim();
    if (RegExp(r'^\s{5}[a-zA-Z0-9_]+:\s*$').hasMatch(raw)) {
      // flush previous
      if (currentPkg != null && status == 'experimental') {
        final ageDays = pkgSince == null ? 0 : now.difference(pkgSince).inDays;
        if (ageDays > maxDays) {
          violations.add(
            '$currentPkg experimental for $ageDays>d (max $maxDays)',
          );
        }
      }
      currentPkg = trimmed.substring(0, trimmed.length - 1);
      status = null;
      pkgSince = null;
      continue;
    }
    if (trimmed.startsWith('status:')) {
      status = trimmed.split(':').last.trim();
    } else if (trimmed.startsWith('since:')) {
      final v = trimmed.split(':').last.trim().replaceAll("'", '');
      final parsed = DateTime.tryParse(v);
      if (parsed != null) pkgSince = parsed.toUtc();
    }
  }
  if (currentPkg != null && status == 'experimental') {
    final ageDays = pkgSince == null ? 0 : now.difference(pkgSince).inDays;
    if (ageDays > maxDays)
      violations.add('$currentPkg experimental for $ageDays>d (max $maxDays)');
  }
  if (violations.isEmpty) {
    stdout.writeln(
      'Package status audit OK (experimental within $maxDays days).',
    );
    return;
  }
  for (final v in violations) {
    stdout.writeln('WARNING: $v');
  }
  if (strict) {
    stderr.writeln(
      'Failing due to STRICT_PACKAGE_STATUS=1 and violations present.',
    );
    exit(2);
  }
}
