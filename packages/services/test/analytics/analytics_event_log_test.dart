import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:services/economy/simple_economy.dart';
import 'package:services/analytics/testing.dart';

void main() {
  test('Writes analytics events log ndjson', () {
    final econ = SimpleEconomy(onEvent: (e, p) {
      final line =
          '{"event":"$e","currency":"${p['currency']}","amount":${p['amount']}}\n';
      appendAnalyticsNdjsonLine(line);
    });
    econ.award('coins', 10);
    econ.spend('coins', 5);
    final outFile = File('build/metrics/analytics_events.ndjson');
    expect(outFile.existsSync(), true);
    final lines = outFile.readAsLinesSync();
    expect(lines.length >= 2, true);
  });
}
