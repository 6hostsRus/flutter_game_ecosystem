import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:services/economy/simple_economy.dart';
import 'package:services/analytics/testing.dart';

void main() {
  test('SimpleEconomy emits analytics events on award/spend', () {
    final events = <Map<String, Object?>>[];
    final econ = SimpleEconomy(onEvent: (e, p) {
      final rec = {
        'event': e,
        ...p,
        'ts': DateTime.now().toUtc().toIso8601String(),
      };
      events.add(rec);
      appendAnalyticsNdjsonLine(jsonEncode(rec) + '\n');
    });
    econ.award('coins', 100, reason: 'quest');
    econ.spend('coins', 40, reason: 'upgrade');
    final deltaEvents =
        events.where((e) => e['event'] == 'economy_delta').toList();
    expect(deltaEvents.length, 2);
    expect(deltaEvents.first['amount'], 100);
    expect(deltaEvents.last['amount'], -40);
    expect(deltaEvents.last['balance'], 60);
  });
}
