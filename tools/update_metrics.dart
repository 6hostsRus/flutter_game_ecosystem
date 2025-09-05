// change-class: infra
// Updates docs/METRICS.md AUTO markers.
import 'dart:io';

void main() {
  final metricsFile = File('docs/METRICS.md');
  if (!metricsFile.existsSync()) {
    stderr.writeln('docs/METRICS.md not found');
    exit(1);
  }
  final manifest = File('packages/manifest.yaml');
  int packageCount = 0;
  if (manifest.existsSync()) {
    final lines = manifest.readAsLinesSync();
    for (final l in lines) {
      if (l.trimLeft().startsWith(RegExp(r'^[a-zA-Z0-9_-]+:')) &&
          l.contains('path:')) {
        // naive
      }
    }
    // more robust yaml parse skipped (avoid dependency); simple count of '  <name>:' under packages section.
    bool inPackages = false;
    for (final l in lines) {
      if (l.startsWith('packages:')) {
        inPackages = true;
        continue;
      }
      if (inPackages) {
        if (RegExp(r'^\s{2}[a-zA-Z0-9_\-]+:').hasMatch(l)) packageCount++;
        if (!l.startsWith('  ') && l.trim().isNotEmpty) inPackages = false;
      }
    }
  }

  String content = metricsFile.readAsStringSync();
  content = _replace(
    content,
    'AUTO:PACKAGE_COUNT',
    'Package count: $packageCount',
  );

  // Coverage: look for top-level lcov.info (aggregate) or in coverage/.
  final lcovFile = File('coverage/lcov.info');
  if (lcovFile.existsSync()) {
    final pct = _parseLcovCoverage(lcovFile.readAsLinesSync());
    content = _replace(
      content,
      'AUTO:COVERAGE',
      'Coverage: ${pct.toStringAsFixed(1)}%',
    );
    _writeCoverageBadge(pct);
  }

  // Stub parity timestamp: only stamp if env var set (CI sets STUB_PARITY_OK=1 after parity script).
  final parityOk = Platform.environment['STUB_PARITY_OK'] == '1';
  if (parityOk) {
    content = _replace(
      content,
      'AUTO:STUB_PARITY',
      'Stub parity: OK @ ${DateTime.now().toUtc().toIso8601String()}',
    );
  }
  metricsFile.writeAsStringSync(content);
  stdout.writeln('Updated metrics (package count=$packageCount)');
}

String _replace(String text, String marker, String value) {
  final pattern = RegExp('<!-- $marker -->(.*?)<!-- END -->', dotAll: true);
  return text.replaceAllMapped(
    pattern,
    (m) => '<!-- $marker -->$value<!-- END -->',
  );
}

double _parseLcovCoverage(List<String> lines) {
  int foundLines = 0;
  int hitLines = 0;
  for (final l in lines) {
    if (l.startsWith('DA:')) {
      foundLines++;
      final parts = l.substring(3).split(',');
      if (parts.length == 2 && parts[1].trim() != '0') hitLines++;
    }
  }
  if (foundLines == 0) return 0;
  return (hitLines / foundLines) * 100.0;
}

void _writeCoverageBadge(double pct) {
  final dir = Directory('docs/badges');
  if (!dir.existsSync()) dir.createSync(recursive: true);
  final color = () {
    if (pct < 30) return 'red';
    if (pct < 60) return 'orange';
    if (pct < 80) return 'yellow';
    if (pct < 95) return 'green';
    return 'brightgreen';
  }();
  final file = File('${dir.path}/coverage.json');
  file.writeAsStringSync('''{
  "schemaVersion": 1,
  "label": "coverage",
  "message": "${pct.toStringAsFixed(1)}%",
  "color": "$color"
}''');
}
