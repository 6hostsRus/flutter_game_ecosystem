import 'package:flutter_test/flutter_test.dart';
import 'package:services/economy/economy_profile_adapter.dart';
import 'package:services/economy/simple_economy.dart';
import 'package:services/save/memory_profile_store.dart';

void main() {
  test('EconomyProfileAdapter save/load round trip', () {
    final econ = SimpleEconomy();
    final store = InMemoryProfileStore();
    final adapter = EconomyProfileAdapter(economy: econ, profile: store);

    // Save initial balances.
    adapter.save({'coins': 500, 'premium': 2});
    final loaded = adapter.load();
    expect(loaded['coins'], 500);
    expect(loaded['premium'], 2);

    // Overwrite with new balances.
    adapter.save({'coins': 80});
    final loaded2 = adapter.load();
    expect(loaded2['coins'], 80);
    expect(loaded2.containsKey('premium'), isFalse);

    // JSON export stable.
    final json = adapter.exportJson();
    expect(json.contains('"coins":80'), isTrue);
  });
}
