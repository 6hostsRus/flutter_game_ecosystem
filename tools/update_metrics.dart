// change-class: infra
// Updates docs/METRICS.md AUTO markers.
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

void main() {
  final metricsFile = File('docs/METRICS.md');
  if (!metricsFile.existsSync()) {
    stderr.writeln('docs/METRICS.md not found');
    exit(1);
  }
  final readmeFile = File('README.md');
  final manifest = File('packages/manifest.yaml');
  int packageCount = 0;
  if (manifest.existsSync()) {
    final lines = manifest.readAsLinesSync();
    bool inPackages = false;
    for (final raw in lines) {
      final l = raw.replaceAll('\t', '    '); // normalize tabs
      if (l.trim().startsWith('packages:')) {
        inPackages = true;
        continue;
      }
      if (!inPackages) continue;
      // Detect new top-level package key (indented at least one space and ending with colon, not 'path:' etc.).
      if (RegExp(r'^\s{1,}[a-zA-Z0-9_\-]+:\s*$').hasMatch(l)) {
        final key = l.trim().substring(0, l.trim().length - 1);
        if (key != 'path' &&
            key != 'role' &&
            key != 'status' &&
            key != 'owner' &&
            key != 'domain' &&
            key != 'notes') {
          packageCount++;
        }
      }
      // Leave block when we reach a non-indented line or new root key.
      if (inPackages &&
          !l.startsWith(' ') &&
          l.trim().isNotEmpty &&
          !l.trim().startsWith('#')) {
        inPackages = false;
      }
    }
  }

  String content = metricsFile.readAsStringSync();
  content = _replace(
    content,
    'AUTO:PACKAGE_COUNT',
    'Package count: $packageCount',
  );

  // README mirrors
  if (readmeFile.existsSync()) {
    String readme = readmeFile.readAsStringSync();
    readme = _replace(
      readme,
      'AUTO:README_PACKAGE_COUNT',
      'Package count: $packageCount',
    );
    readmeFile.writeAsStringSync(readme);
  }

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
    if (readmeFile.existsSync()) {
      final rd = readmeFile.readAsStringSync();
      readmeFile.writeAsStringSync(
        _replace(
          rd,
          'AUTO:README_COVERAGE',
          'Coverage: ${pct.toStringAsFixed(1)}%',
        ),
      );
    }
  }

  // NOTE: Parity timestamp gating now requires BOTH STUB_PARITY_OK=1 and matching STUB_PARITY_SPEC_HASH.
  // We compute the hash below, so we stage stamping until after hash calculation.
  bool stampParity = false;
  final parityOkEnv = Platform.environment['STUB_PARITY_OK'] == '1';
  final expectedHashEnv = Platform.environment['STUB_PARITY_SPEC_HASH'];

  // Parity spec hash: stable fingerprint of critical stub + parity checker sources.
  final specFiles = [
    'tools/check_stub_parity.dart',
    'packages/in_app_purchase/lib/in_app_purchase.dart',
    'packages/services/core_services_isar/lib/core_services_isar/src/wallet_service_isar.dart',
  ];
  final buffer = BytesBuilder();
  for (final p in specFiles) {
    final f = File(p);
    if (f.existsSync()) {
      buffer.add(utf8.encode(p));
      buffer.add(f.readAsBytesSync());
    }
  }
  final hash = sha1.convert(buffer.toBytes()).toString();
  content = _replace(
    content,
    'AUTO:PARITY_SPEC_HASH',
    'Parity spec hash: $hash',
  );
  if (parityOkEnv && expectedHashEnv != null && expectedHashEnv == hash) {
    stampParity = true;
  }
  if (stampParity) {
    content = _replace(
      content,
      'AUTO:STUB_PARITY',
      'Stub parity: OK @ ${DateTime.now().toUtc().toIso8601String()}',
    );
    if (readmeFile.existsSync()) {
      final rd = readmeFile.readAsStringSync();
      readmeFile.writeAsStringSync(
        _replace(rd, 'AUTO:README_STUB_PARITY', 'Stub parity: OK'),
      );
    }
  }

  // SKU rewards count: prefer JSON config if present.
  int? skuCount;
  final jsonRewards = File(
    'packages/services/lib/monetization/sku_rewards.json',
  );
  if (jsonRewards.existsSync()) {
    try {
      final map = jsonDecode(jsonRewards.readAsStringSync());
      if (map is Map) skuCount = map.length;
    } catch (_) {}
  }
  if (skuCount == null) {
    // Fallback: legacy Dart constant parsing (for backward compatibility).
    final skuDart = File('packages/services/lib/monetization/sku_rewards.dart');
    if (skuDart.existsSync()) {
      final txt = skuDart.readAsStringSync();
      final match = RegExp(
        r'_defaultRewards\s*=\s*{([\s\S]*?)};',
      ).firstMatch(txt);
      if (match != null) {
        int count = 0;
        for (final line in match.group(1)!.split('\n')) {
          if (RegExp(r"^\s*'[^']+'\s*:").hasMatch(line)) count++;
        }
        skuCount = count;
      }
    }
  }
  if (skuCount != null) {
    content = _replace(content, 'AUTO:SKU_REWARDS', 'SKU rewards: $skuCount');
  }

  // Reward events count (optional, from build artifact if present).
  final rewardEventsFile = File('build/metrics/reward_events_count.txt');
  if (rewardEventsFile.existsSync()) {
    final cntStr = rewardEventsFile.readAsStringSync().trim();
    final cnt = int.tryParse(cntStr) ?? 0;
    content = _replace(
      content,
      'AUTO:REWARD_EVENTS',
      'Reward events (lifetime local build): $cnt',
    );
  }

  // Per-package coverage breakdown (best-effort: look for packages/**/coverage/lcov.info)
  final breakdown = <String>[];
  final pkgsDir = Directory('packages');
  if (pkgsDir.existsSync()) {
    for (final entity in pkgsDir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('coverage/lcov.info')) {
        final pkgPath = entity.path;
        // Extract package dir name (two levels up from coverage/lcov.info if nested).
        final segments = pkgPath.split('/');
        final pkgIndex = segments.lastIndexOf('coverage') - 1;
        String pkgName;
        if (pkgIndex >= 0) {
          pkgName = segments[pkgIndex];
        } else {
          pkgName = pkgPath; // fallback
        }
        final lines = entity.readAsLinesSync();
        final pct = _parseLcovCoverage(lines);
        breakdown.add('$pkgName: ${pct.toStringAsFixed(1)}%');
      }
    }
  }
  if (breakdown.isNotEmpty) {
    breakdown.sort((a, b) {
      // a: 'pkg: 12.3%'
      double pct(String s) {
        final m = RegExp(r':\s+([0-9]+\.?[0-9]*)%').firstMatch(s);
        return m == null ? 0 : double.tryParse(m.group(1)!) ?? 0;
      }

      return pct(a).compareTo(pct(b));
    });
    content = _replace(
      content,
      'AUTO:COVERAGE_BREAKDOWN',
      'Per-package coverage:\n' + breakdown.join('\\n'),
    );
  }

  // Economy metrics (best-effort): look for modules/content_packs/**/economy.json or top-level economy schema usage.
  final economyCurrencySet = <String>{};
  int offersCount = 0;
  void _scanEconomyFile(File f) {
    try {
      final map = jsonDecode(f.readAsStringSync());
      if (map is Map<String, dynamic>) {
        final currencies = map['currencies'];
        if (currencies is List) {
          for (final c in currencies) {
            if (c is String) economyCurrencySet.add(c);
          }
        }
        final offers = map['offers'];
        if (offers is List) {
          offersCount += offers.length;
        }
      }
    } catch (_) {}
  }

  // Scan content packs for economy.json
  final contentPacksDir = Directory('modules/content_packs');
  if (contentPacksDir.existsSync()) {
    for (final pack in contentPacksDir.listSync(recursive: true)) {
      if (pack is File && pack.path.endsWith('/economy.json')) {
        _scanEconomyFile(pack);
      }
    }
  }
  // If none found, attempt a default economy.json at root of each pack manifest reference.
  // (No extra logic yet.)
  if (economyCurrencySet.isNotEmpty || offersCount > 0) {
    content = _replace(
      content,
      'AUTO:ECONOMY_CURRENCIES',
      'Economy currencies: ${economyCurrencySet.length}',
    );
    content = _replace(
      content,
      'AUTO:ECONOMY_OFFERS',
      'Economy offers: $offersCount',
    );
  }

  // Analytics metrics: parse build/metrics/analytics_events.ndjson if exists.
  final analyticsEventsLog = File('build/metrics/analytics_events.ndjson');
  int analyticsEventCount = 0;
  if (analyticsEventsLog.existsSync()) {
    analyticsEventCount +=
        analyticsEventsLog
            .readAsLinesSync()
            .where((l) => l.trim().isNotEmpty)
            .length;
  }
  // Scan package-level build metrics logs.
  for (final e in Directory('packages').listSync(recursive: true)) {
    if (e is File && e.path.endsWith('build/metrics/analytics_events.ndjson')) {
      analyticsEventCount +=
          e.readAsLinesSync().where((l) => l.trim().isNotEmpty).length;
    }
  }
  content = _replace(
    content,
    'AUTO:ANALYTICS_EVENTS',
    'Analytics events (test session): $analyticsEventCount',
  );
  // Analytics test count: look for *_analytics_test.dart files.
  final analyticsTestFiles = <String>[];
  final pkRoot = Directory('packages');
  if (pkRoot.existsSync()) {
    for (final e in pkRoot.listSync(recursive: true)) {
      if (e is File &&
          e.path.contains('/test/analytics/') &&
          e.path.endsWith('_analytics_test.dart')) {
        analyticsTestFiles.add(e.path);
      }
    }
  }
  if (analyticsTestFiles.isNotEmpty) {
    content = _replace(
      content,
      'AUTO:ANALYTICS_TESTS',
      'Analytics tests: ${analyticsTestFiles.length}',
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
