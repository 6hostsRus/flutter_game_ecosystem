// check_perf_metrics.dart
// Validates perf metrics written by PerfHarness against simple thresholds.
// Usage:
//   dart run tools/check_perf_metrics.dart --file packages/services/build/metrics/perf_simulation.json \
//     --max-p95-us 10000 --min-spends 80 --min-awards 120 --min-purchases 40

import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final path =
      _arg(args, '--file') ??
      'packages/services/build/metrics/perf_simulation.json';
  final maxP95 = int.parse(_arg(args, '--max-p95-us') ?? '12000');
  final minSpends = int.parse(_arg(args, '--min-spends') ?? '100');
  final minAwards = int.parse(_arg(args, '--min-awards') ?? '150');
  final minPurchases = int.parse(_arg(args, '--min-purchases') ?? '50');

  final f = File(path);
  if (!f.existsSync()) {
    stderr.writeln('Perf metrics file not found: $path');
    exit(2);
  }
  final json = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
  final perf = (json['perf'] as Map<String, dynamic>);
  final ticks = (perf['ticks_us'] as Map<String, dynamic>);
  final p95 = (ticks['p95'] as num).toInt();
  final awards = (json['awards'] as num).toInt();
  final spends = (json['spends'] as num).toInt();
  final purchases = (json['purchases'] as num).toInt();

  final failures = <String>[];
  if (p95 > maxP95) failures.add('p95_us=$p95 exceeds threshold $maxP95');
  if (awards < minAwards) failures.add('awards=$awards below $minAwards');
  if (spends < minSpends) failures.add('spends=$spends below $minSpends');
  if (purchases < minPurchases)
    failures.add('purchases=$purchases below $minPurchases');

  if (failures.isNotEmpty) {
    stderr.writeln('Perf metrics check failed:');
    for (final f in failures) {
      stderr.writeln(' - $f');
    }
    exit(1);
  }
  stdout.writeln(
    'Perf metrics OK: p95=$p95, awards=$awards, spends=$spends, purchases=$purchases',
  );
}

String? _arg(List<String> args, String name) {
  final i = args.indexOf(name);
  if (i == -1 || i + 1 >= args.length) return null;
  return args[i + 1];
}
