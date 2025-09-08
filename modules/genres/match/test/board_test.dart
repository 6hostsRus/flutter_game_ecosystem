import 'package:flutter_test/flutter_test.dart';
import 'package:match/match.dart';
import 'package:game_core/game_core.dart';

void main() {
  group('MatchBoard', () {
    test('deterministic fill with seed', () {
      final board = MatchBoard(5, 5, kinds: 4);
      // initialize to -1 so fill populates
      for (var i = 0; i < board.cells.length; i++) {
        board.cells[i] = -1;
      }
      final rng = DeterministicRng(42);
      board.fill(rng);

      final snapshot = List<int>.from(board.cells);

      // Recreate and fill again with same seed should match
      final board2 = MatchBoard(5, 5, kinds: 4);
      for (var i = 0; i < board2.cells.length; i++) {
        board2.cells[i] = -1;
      }
      board2.fill(DeterministicRng(42));

      expect(board2.cells, equals(snapshot));
    });

    test('swap creates a match, then clear and gravity', () {
      // 5x5 board, kinds=3 for simplicity
      final b = MatchBoard(5, 5, kinds: 3);
      // Layout chosen so swapping (1,2)<->(2,2) forms horizontal match at row 2
      // y=0 top
      final layout = [
        // row 0
        0, 1, 2, 0, 1,
        // row 1
        2, 0, 1, 2, 0,
        // row 2
        1, 2, 1, 1, 0,
        // row 3
        0, 1, 2, 0, 1,
        // row 4
        2, 0, 1, 2, 0,
      ];
      expect(layout.length, b.cells.length);
      for (var i = 0; i < b.cells.length; i++) {
        b.cells[i] = layout[i];
      }

      final matched = b.trySwap(0, 2, 1, 2); // swap to create 1,1,1 at x=1..3
      expect(matched.isNotEmpty, isTrue);
      // Ensure at least these indices are matched (1,2),(2,2),(3,2) => indices 5*2+[1..3]
      expect(matched.containsAll({b.index(1, 2), b.index(2, 2), b.index(3, 2)}),
          isTrue);

      b.clearAndGravity(matched);
      // After clear, those positions are -1 before gravity resolves
      // Gravity compacts; fill new with deterministic RNG
      final rng = DeterministicRng(7);
      b.fill(rng);

      // Board should have no -1 after fill
      expect(b.cells.where((v) => v < 0), isEmpty);
    });

    test('no-op swap reverts if no match', () {
      final b = MatchBoard(3, 3, kinds: 3);
      // Simple layout with no immediate match and swapping corners shouldn't match
      final layout = [
        0,
        1,
        2,
        1,
        2,
        0,
        2,
        0,
        1,
      ];
      for (var i = 0; i < b.cells.length; i++) {
        b.cells[i] = layout[i];
      }
      final before = List<int>.from(b.cells);
      final matched = b.trySwap(0, 0, 1, 0);
      expect(matched, isEmpty);
      expect(b.cells, equals(before));
    });

    test('resolveCascades repeats until stable and returns total cleared', () {
      final b = MatchBoard(4, 4, kinds: 3);
      // Construct a board with both a horizontal and vertical match that will cascade
      // Use -1 to mark empties that will be filled deterministically
      final layout = <int>[
        // y=0
        0, 0, 0, -1,
        // y=1
        1, 2, 1, -1,
        // y=2 (vertical match in column 3 after first fill likely)
        -1, -1, -1, -1,
        // y=3
        2, 1, 2, -1,
      ];
      for (var i = 0; i < b.cells.length; i++) {
        b.cells[i] = layout[i];
      }
      // Initial fill to remove -1s deterministically, then force a cascade via trySwap
      final rng = DeterministicRng(99);
      b.fill(rng);
      // Create a match via swap to kick off cascades
      final initial = b.findMatches();
      if (initial.isEmpty) {
        // Try a local swap to produce a match
        final _ = b.trySwap(0, 1, 1, 1);
      }
      final total = b.resolveCascades(DeterministicRng(99));
      expect(total >= 3, isTrue); // At least one match cleared
      expect(b.findMatches().isEmpty, isTrue); // Stable
    });
  });
}
