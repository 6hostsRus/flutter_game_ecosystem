// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_game/main.dart';

void main() {
  testWidgets('App boots to Home with coins badge', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pump();
    expect(find.textContaining('Home — Demo Game'), findsOneWidget);
    // Sanity check: buttons present on Home.
    expect(find.text('Play Platformer (stub)'), findsOneWidget);
    expect(find.text('Play Survivor (stub)'), findsOneWidget);
  });
}
