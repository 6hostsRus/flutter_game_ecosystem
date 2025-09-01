import 'package:flutter_test/flutter_test.dart';
import 'package:services/save/profile_store.dart';

void main() {
  test('ProfileKey toString is stable', () {
    const k = ProfileKey('economy', 'balances');
    expect(k.toString(), 'economy/balances');
  });
}
