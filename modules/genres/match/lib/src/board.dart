import 'dart:math';

class MatchBoard {
  final int width;
  final int height;
  final int kinds; // number of gem types [0..kinds-1]
  final List<int> cells;

  MatchBoard(this.width, this.height, {this.kinds = 5})
      : cells = List<int>.filled(width * height, 0);

  int index(int x, int y) => y * width + x;
  bool inBounds(int x, int y) => x >= 0 && x < width && y >= 0 && y < height;

  void swap(int x1, int y1, int x2, int y2) {
    final i1 = index(x1, y1), i2 = index(x2, y2);
    final tmp = cells[i1];
    cells[i1] = cells[i2];
    cells[i2] = tmp;
  }

  /// Attempt to swap; if it yields no matches, revert and return empty set.
  /// Returns the set of matched indices after the swap (before clear/gravity).
  Set<int> trySwap(int x1, int y1, int x2, int y2) {
    swap(x1, y1, x2, y2);
    final matched = findMatches();
    if (matched.isEmpty) {
      // revert
      swap(x1, y1, x2, y2);
    }
    return matched;
  }

  /// Fill empty cells (-1) or initialize board using provided RNG.
  void fill(Random rng) {
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final i = index(x, y);
        if (cells[i] < 0) {
          cells[i] = rng.nextInt(kinds);
        }
      }
    }
  }

  /// Find all cells in matches of length >= 3 horizontally or vertically.
  Set<int> findMatches() {
    final matched = <int>{};
    // Horizontal
    for (var y = 0; y < height; y++) {
      var runStart = 0;
      while (runStart < width) {
        final v = cells[index(runStart, y)];
        var runEnd = runStart + 1;
        while (runEnd < width && cells[index(runEnd, y)] == v) {
          runEnd++;
        }
        final len = runEnd - runStart;
        if (v >= 0 && len >= 3) {
          for (var x = runStart; x < runEnd; x++) {
            matched.add(index(x, y));
          }
        }
        runStart = runEnd;
      }
    }
    // Vertical
    for (var x = 0; x < width; x++) {
      var runStart = 0;
      while (runStart < height) {
        final v = cells[index(x, runStart)];
        var runEnd = runStart + 1;
        while (runEnd < height && cells[index(x, runEnd)] == v) {
          runEnd++;
        }
        final len = runEnd - runStart;
        if (v >= 0 && len >= 3) {
          for (var y = runStart; y < runEnd; y++) {
            matched.add(index(x, y));
          }
        }
        runStart = runEnd;
      }
    }
    return matched;
  }

  /// Clear matched cells to -1 and apply gravity.
  void clearAndGravity(Set<int> matched) {
    for (final i in matched) {
      cells[i] = -1;
    }
    // Gravity: for each column, compact down.
    for (var x = 0; x < width; x++) {
      var write = height - 1;
      for (var y = height - 1; y >= 0; y--) {
        final i = index(x, y);
        if (cells[i] >= 0) {
          final w = index(x, write);
          cells[w] = cells[i];
          if (w != i) cells[i] = -1;
          write--;
        }
      }
    }
  }
}
