import 'package:flutter_test/flutter_test.dart';
import 'package:services/economy/economy_port.dart';

void main() {
  test('CurrencyDelta toString doesn\'t crash', () {
    const d = CurrencyDelta(currency: 'soft', amount: 100, reason: 'reward');
    expect(d.currency, 'soft');
  });
}
