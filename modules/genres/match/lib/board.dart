// ignore_for_file: public_member_api_docs

import 'dart:math';
import 'board_config.dart';
import 'hooks.dart';

/// A minimal, deterministic Match-3 engine that consumes [BoardConfig].
/// - Width/height/kinds driven by cfg
/// - Deterministic RNG via cfg.rngSeed and [reseed]
/// - Basic line-3 detection (horizontal + vertical)
/// - Gravity: down; Refill: bag/random based on cfg.refill
/// - Event hook calls at key lifecycle points
class MatchBoard {
  final BoardConfig cfg;
  final List<BoardEventHook> hooks;

  late final Random _rng;
  late List<int> _cells; // flattened grid of tile kind indices

  int get width => cfg.width;
  int get height => cfg.height;
  int get kinds => cfg.kinds;
  List<int> get cells => List.unmodifiable(_cells);

  MatchBoard(this.cfg, {List<BoardEventHook> hooks = const []})
      : hooks = List.from(hooks) {
    _rng = Random(cfg.rngSeed ?? DateTime.now().millisecondsSinceEpoch);
    _cells = List<int>.filled(width * height, 0);
    _fillInitial();
    _notifyBoardStable();
  }

  void reseed(int seed) {
    _rng = Random(seed);
  }

  int index(int x, int y) => y * width + x;
  bool inBounds(int x, int y) => x >= 0 && x < width && y >= 0 && y < height;

  void _fillInitial() {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        _cells[index(x, y)] = _nextSpawn();
      }
    }
    // Optional: resolve any immediate matches by rerolling; omitted for simplicity.
  }

  int _nextSpawn() {
    final weights = cfg.weights;
    if (weights == null || weights.isEmpty) {
      return _rng.nextInt(kinds);
    }
    // Weighted spawn
    final sum = weights.fold<double>(0, (a, b) => a + b);
    double roll = _rng.nextDouble() * sum;
    for (int k = 0; k < kinds; k++) {
      final w = weights[k];
      if ((roll -= w) <= 0) return k;
    }
    return kinds - 1;
  }

  bool areAdjacent(int ax, int ay, int bx, int by) {
    final dx = (ax - bx).abs();
    final dy = (ay - by).abs();
    return (dx == 1 && dy == 0) || (dx == 0 && dy == 1);
  }

  /// Attempts a swap. If no match results, reverts the swap.
  /// Returns true if the move was valid (produced a match).
  bool trySwap(int ax, int ay, int bx, int by) {
    if (!inBounds(ax, ay) || !inBounds(bx, by) || !areAdjacent(ax, ay, bx, by)) {
      return false;
    }
    hooks.forEach((h) => h.onSwap({'a':[ax,ay],'b':[bx,by]}));

    final ai = index(ax, ay);
    final bi = index(bx, by);
    final tmp = _cells[ai];
    _cells[ai] = _cells[bi];
    _cells[bi] = tmp;

    final matched = _findMatches();
    if (matched.isEmpty) {
      // revert
      _cells[bi] = _cells[ai];
      _cells[ai] = tmp;
      return false;
    }

    _resolveCascades(matched);
    return true;
  }

  Set<int> _findMatches() {
    final Set<int> match = {};
    // horizontal
    for (int y = 0; y < height; y++) {
      int runLen = 1;
      for (int x = 1; x < width; x++) {
        if (_cells[index(x, y)] == _cells[index(x-1, y)]) {
          runLen++;
        } else {
          if (runLen >= 3) {
            for (int k = 0; k < runLen; k++) {
              match.add(index(x-1-k, y));
            }
          }
          runLen = 1;
        }
      }
      if (runLen >= 3) {
        for (int k = 0; k < runLen; k++) {
          match.add(index(width-1-k, y));
        }
      }
    }
    // vertical
    for (int x = 0; x < width; x++) {
      int runLen = 1;
      for (int y = 1; y < height; y++) {
        if (_cells[index(x, y)] == _cells[index(x, y-1)]) {
          runLen++;
        } else {
          if (runLen >= 3) {
            for (int k = 0; k < runLen; k++) {
              match.add(index(x, y-1-k));
            }
          }
          runLen = 1;
        }
      }
      if (runLen >= 3) {
        for (int k = 0; k < runLen; k++) {
          match.add(index(x, height-1-k));
        }
      }
    }
    if (match.isNotEmpty) {
      hooks.forEach((h) => h.onMatch({'cells': match.toList()}));
    }
    return match;
  }

  void _resolveCascades(Set<int> initial) {
    int cascade = 0;
    Set<int> current = initial;
    while (current.isNotEmpty) {
      // clear
      for (final i in current) {
        _cells[i] = -1; // mark empty
      }
      // gravity down
      for (int x = 0; x < width; x++) {
        int writeY = height - 1;
        for (int y = height - 1; y >= 0; y--) {
          final i = index(x, y);
          if (_cells[i] >= 0) {
            final w = index(x, writeY);
            _cells[w] = _cells[i];
            writeY--;
          }
        }
        // refill
        for (int y = writeY; y >= 0; y--) {
          _cells[index(x, y)] = _nextSpawn();
        }
      }
      hooks.forEach((h) => h.onCascadeEnd({'cascade': cascade}));
      cascade++;
      current = _findMatches();
    }
    _notifyBoardStable();
  }

  void _notifyBoardStable() {
    hooks.forEach((h) => h.onBoardStable({}));
  }
}
