import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_game/main.dart' as demo;
import 'golden_test_helper.dart';

void main() {
  testWidgets('StoreScreen golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester.pumpWidget(const ProviderScope(child: demo.App()));
  await loadFonts();
  await prepareGoldenTest(tester);

    // Navigate to Store tab via stable Key.
    await tester.tap(find.byKey(const Key('nav:dest:store')));
    for (int i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 40));
    }
    expect(find.byKey(const Key('store:button')), findsOneWidget);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../goldens/store_screen.png'),
    );
  });
}
