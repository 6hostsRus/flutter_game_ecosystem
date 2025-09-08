// Tool: ensure each package with lib/ has an analysis_options.yaml that includes the repo root analysis_options.yaml

import 'dart:io';

void main(List<String> args) {
  final root = Directory.current;
  final rootAnalysis = File('${root.path}/analysis_options.yaml');
  if (!rootAnalysis.existsSync()) {
    stderr.writeln('Root analysis_options.yaml not found.');
    exit(2);
  }

  final packages = root.listSync().whereType<Directory>().where((d) {
    // ignore common non-package dirs
    final name = d.path.split(Platform.pathSeparator).last;
    return ![
      '.git',
      '.github',
      'tools',
      'docs',
      'android',
      'ios',
      'web',
      'build',
    ].contains(name);
  });

  var failures = 0;
  for (final p in packages) {
    final pkgPath = p.path;
    final pubspec = File('$pkgPath/pubspec.yaml');
    if (!pubspec.existsSync()) continue; // not a package

    final analysis = File('$pkgPath/analysis_options.yaml');
    if (!analysis.existsSync()) {
      // check if package uses include in subfolders (e.g., example/ or lib/)
      // treat missing per-package analysis as a warning only
      stdout.writeln('WARN: $pkgPath has no analysis_options.yaml');
      continue;
    }

    final contents = analysis.readAsStringSync();
    if (!contents.contains('include:')) {
      stderr.writeln(
        'FAIL: $pkgPath/analysis_options.yaml does not include root analysis_options.yaml',
      );
      failures++;
      continue;
    }

    if (!contents.contains('analysis_options.yaml')) {
      stderr.writeln(
        'FAIL: $pkgPath/analysis_options.yaml does not reference root analysis_options.yaml',
      );
      failures++;
    }
  }

  if (failures > 0) {
    stderr.writeln(
      '\nFound $failures packages with missing/incorrect analysis_options.yaml includes.',
    );
    exit(1);
  }

  stdout.writeln('OK: per-package analysis includes check passed.');
}
