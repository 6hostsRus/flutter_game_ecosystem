import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_game/main.dart' as demo;

void main() {
  testWidgets('platformer & survivor buttons push expected modals',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: demo.App()));
    await tester.pump(const Duration(milliseconds: 200));
    // Ensure Home tab selected so buttons are visible.
    final destFinder = find.byType(NavigationDestination);
    if (destFinder.evaluate().isNotEmpty) {
      await tester.tap(destFinder.at(0));
      await tester.pump(const Duration(milliseconds: 200));
    }

    Future<void> openAndVerify(String label, String expectedTitle) async {
      final labelFinder = find.text(label);
      expect(labelFinder, findsOneWidget, reason: 'Label "$label" not found');
      await tester.tap(labelFinder);
      await tester.pump();
      // Allow push animation
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text(expectedTitle), findsOneWidget,
          reason:
              'Expected app bar title "$expectedTitle" after opening $label modal');
      // Pop route
      Navigator.of(tester.element(find.text(expectedTitle))).pop();
      await tester.pumpAndSettle();
    }

    await openAndVerify('Play Platformer (stub)', 'Platformer');
    await openAndVerify('Play Survivor (stub)', 'Survivor');
  });
}
