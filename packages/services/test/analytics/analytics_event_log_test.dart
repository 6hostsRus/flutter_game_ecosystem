import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:services/economy/simple_economy.dart';

void main() {
  test('Writes analytics events log ndjson', () {
    final outFile = File('build/metrics/analytics_events.ndjson');
    outFile.parent.createSync(recursive: true);
    final rootOut = File('../../build/metrics/analytics_events.ndjson');
    rootOut.parent.createSync(recursive: true);
    final econ = SimpleEconomy(onEvent: (e, p) {
      final line =
          '{"event":"$e","currency":"${p['currency']}","amount":${p['amount']}}\n';
      outFile.writeAsStringSync(line, mode: FileMode.append);
      rootOut.writeAsStringSync(line, mode: FileMode.append);
    });
    econ.award('coins', 10);
    econ.spend('coins', 5);
    expect(outFile.existsSync(), true);
    final lines = outFile.readAsLinesSync();
    expect(lines.length >= 2, true);
    expect(rootOut.existsSync(), true);
  });
}
