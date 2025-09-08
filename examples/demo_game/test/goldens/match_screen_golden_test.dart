import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:match/match.dart';

void main() {
  testWidgets('Match-3 screen golden (seed 42)', (tester) async {
    // Build a minimal scaffold that hosts the board; avoid feature flags.
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: MatchBoardView(
              width: 6,
              height: 6,
              kinds: 5,
              seed: 42,
              cellSize: 24,
            ),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('../../goldens/match_screen.png'),
    );
  });
}
