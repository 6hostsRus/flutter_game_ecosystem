import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../lib/main.dart' as demo;

// Enhanced route integrity: actually tap bottom navigation destinations
// and assert distinguishing content appears for each tab.
void main() {
  testWidgets('bottom navigation switches between tab screens', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: demo.App()));
    await tester.pump();

    final destFinder = find.byType(NavigationDestination);
    expect(destFinder, findsNWidgets(5));

    Future<void> expectTab(int index, Pattern expectedText) async {
      await tester.tap(destFinder.at(index));
      // Allow NavigationBar animation to progress.
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 40));
      }
      expect(find.textContaining(expectedText), findsWidgets,
          reason: 'Expected "$expectedText" after selecting tab $index');
    }

    // Tab order derived from GameTab enum ordering (home, upgrades, items, store, quests)
    await expectTab(0, 'Home');
    await expectTab(1, 'Double Income');
    await expectTab(2, 'Iron Sword');
    await expectTab(3, 'Open Store');
    await expectTab(4, 'Log in');
  });
}
