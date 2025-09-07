import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_shell/ui_shell.dart';

void main() {
  group('GameNavScaffold keys', () {
    Widget _app({GameTab initial = GameTab.home}) => MaterialApp(
          home: GameNavScaffold(
            initialTab: initial,
            showLabels: true,
            tabs: {
              for (final t in GameTab.values)
                t: (_) => Center(child: Text('tab:${t.name}')),
            },
          ),
        );

    testWidgets('exposes stable keys for scaffold, nav bar, and destinations',
        (tester) async {
      await tester.pumpWidget(_app());
      expect(find.byKey(const Key('GameNavScaffold')), findsOneWidget);
      expect(find.byKey(const Key('nav:bar')), findsOneWidget);

      for (final t in GameTab.values) {
        expect(find.byKey(Key('nav:dest:${t.name}')), findsOneWidget);
      }
    });

    testWidgets('body subtree is keyed by current tab and updates on tap',
        (tester) async {
      await tester.pumpWidget(_app(initial: GameTab.items));
      expect(find.byKey(const Key('tab:items')), findsOneWidget);

      // Tap Store destination and verify key swap
      await tester.tap(find.byKey(const Key('nav:dest:store')));
      await tester.pumpAndSettle(const Duration(milliseconds: 50));
      expect(find.byKey(const Key('tab:store')), findsOneWidget);
    });
  });
}
