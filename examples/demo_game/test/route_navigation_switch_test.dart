import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_game/main.dart' as demo;

// Enhanced route integrity: actually tap bottom navigation destinations
// and assert distinguishing content appears for each tab.
void main() {
  testWidgets('bottom navigation switches between tab screens', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: demo.App()));
    await tester.pump();

    Future<void> expectTab(String tabKeySuffix, Pattern expectedText) async {
      await tester.tap(find.byKey(Key('nav:dest:$tabKeySuffix')));
      // Allow NavigationBar animation to progress.
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 40));
      }
      expect(find.textContaining(expectedText), findsWidgets,
          reason: 'Expected "$expectedText" after selecting tab $tabKeySuffix');
    }

    // Tabs referenced by enum names
    await expectTab('home', 'Home');
    await expectTab('upgrades', 'Double Income');
    await expectTab('items', 'Iron Sword');
    await expectTab('store', 'Open Store');
    await expectTab('quests', 'Log in');
  });
}
