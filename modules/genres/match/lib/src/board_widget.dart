import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'board.dart';

/// A simple interactive Match-3 board widget for demos/samples.
/// Tap two adjacent cells to attempt a swap. Successful swaps resolve cascades.
class MatchBoardView extends StatefulWidget {
  final int width;
  final int height;
  final int kinds;
  final int seed;
  final double cellSize;

  const MatchBoardView({
    super.key,
    required this.width,
    required this.height,
    this.kinds = 5,
    this.seed = 1234,
    this.cellSize = 32,
  });

  @override
  State<MatchBoardView> createState() => _MatchBoardViewState();
}

class _MatchBoardViewState extends State<MatchBoardView> {
  late MatchBoard _board;
  late Rng _rng;
  Offset? _selected; // grid coordinates

  static const _palette = <Color>[
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    _board = MatchBoard(widget.width, widget.height, kinds: widget.kinds);
    _rng = DeterministicRng(widget.seed);
    // Initialize to -1 and fill deterministically until stable
    for (var i = 0; i < _board.cells.length; i++) {
      _board.cells[i] = -1;
    }
    _board.fillUntilNoMatches(_rng);
  }

  bool _adjacent(Offset a, Offset b) {
    final dx = (a.dx - b.dx).abs();
    final dy = (a.dy - b.dy).abs();
    return (dx == 1 && dy == 0) || (dx == 0 && dy == 1);
  }

  void _onTapCell(int x, int y) {
    final current = Offset(x.toDouble(), y.toDouble());
    if (_selected == null) {
      setState(() => _selected = current);
      return;
    }
    if (_adjacent(_selected!, current)) {
      final matched =
          _board.trySwap(_selected!.dx.toInt(), _selected!.dy.toInt(), x, y);
      if (matched.isNotEmpty) {
        _board.clearAndGravity(matched);
        _board.resolveCascades(_rng);
      }
      setState(() => _selected = null);
    } else {
      // Select new cell if not adjacent
      setState(() => _selected = current);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.width;
    final h = widget.height;
    final size = widget.cellSize;
    return SizedBox(
      width: w * size,
      height: h * size,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: w,
          childAspectRatio: 1,
        ),
        itemCount: w * h,
        itemBuilder: (context, i) {
          final x = i % w;
          final y = i ~/ w;
          final v = _board.cells[i];
          final isSelected = _selected?.dx == x && _selected?.dy == y;
          final color = v >= 0 ? _palette[v % _palette.length] : Colors.black12;
          return GestureDetector(
            onTap: () => _onTapCell(x, y),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: color,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.black26,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          );
        },
      ),
    );
  }
}
