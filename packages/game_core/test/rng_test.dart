import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';

void main() {
  test('DeterministicRng produces repeatable sequence for same seed', () {
    final a = DeterministicRng(42);
    final b = DeterministicRng(42);

    final seqA = List.generate(5, (_) => a.nextInt(100));
    final seqB = List.generate(5, (_) => b.nextInt(100));
    expect(seqA, seqB);
  });

  test('DeterministicRng differs for different seeds', () {
    final a = DeterministicRng(1);
    final b = DeterministicRng(2);
    final seqA = List.generate(3, (_) => a.nextInt(100));
    final seqB = List.generate(3, (_) => b.nextInt(100));
    expect(seqA, isNot(seqB));
  });

  test('SystemRng nextInt respects bounds', () {
    final r = SystemRng();
    for (var i = 0; i < 10; i++) {
      final v = r.nextInt(10);
      expect(v, inInclusiveRange(0, 9));
    }
  });
}
