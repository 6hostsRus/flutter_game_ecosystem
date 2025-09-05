import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_game/main.dart' as demo;

void main() {
  testWidgets('platformer & survivor buttons push expected modals',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: demo.App()));
    await tester.pumpAndSettle();

    Future<void> openAndVerify(String label, String expectedTitle) async {
      final btn = find.widgetWithText(FilledButton, label).first;
      expect(btn, findsOneWidget, reason: 'Button "$label" not found');
      await tester.tap(btn);
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
