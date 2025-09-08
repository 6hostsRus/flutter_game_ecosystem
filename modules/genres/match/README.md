# match

A tiny, deterministic Match-3 board engine used in tests and examples.

## Features

-    Fixed-size integer grid with K kinds (0..K-1)
-    Swap with revert if no match (trySwap)
-    Match detection (rows/cols, length ≥ 3)
-    Clear + gravity compaction
-    Deterministic fill via game_core Rng (e.g., DeterministicRng)
-    Cascade resolution loop: find → clear → gravity → fill, repeat until stable

## Quick start

```dart
import 'package:match/match.dart';
import 'package:game_core/game_core.dart';

final board = MatchBoard(8, 8, kinds: 5);
// Initialize empties to -1 then fill with a seeded RNG for determinism
for (var i = 0; i < board.cells.length; i++) {
  board.cells[i] = -1;
}
board.fill(DeterministicRng(1234));

// Attempt a swap; if it yields no match, board reverts
final matched = board.trySwap(3, 4, 4, 4);
if (matched.isNotEmpty) {
  board.clearAndGravity(matched);
  board.fill(DeterministicRng(1234));
}

// Or resolve cascades with one call
final cleared = board.resolveCascades(DeterministicRng(999));
```

## API notes

-    Cells are stored as a flat `List<int>`; `index(x,y)` maps coordinates to index.
-    Empty cells are `-1`. Use `fill(Rng)` to populate empties. Provide a seeded RNG for reproducible tests.
-    `trySwap(x1,y1,x2,y2)` swaps adjacent cells and returns the matched set; reverts if no matches.
-    `findMatches()` returns a `Set<int>` of all cells in horizontal or vertical matches ≥ 3.
-    `clearAndGravity(matched)` clears matched cells to -1 and compacts each column downward.
-    `resolveCascades(rng)` loops: matches → clear → gravity → fill, until stable; returns total cells cleared.

## Testing

See `test/board_test.dart` for examples covering deterministic fill, swap/match, clear/gravity, and cascades.
