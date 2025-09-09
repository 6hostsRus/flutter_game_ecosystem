import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'golden_harness.dart';
import 'golden_test_helper.dart';
import 'package:demo_game/main.dart' as demo;
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  setUpAll(() async {
    // registerFontAsset('Arcade', 'assets/fonts/Arcade.ttf');
    await loadFonts();
  });

  runGoldenAlchemist(
    name: 'StoreScreen golden',
    fileName: 'store_screen',
    builder: () => const ProviderScope(child: demo.App()),
    pumpBeforeTest: (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await prepareGoldenTest(tester);
    },
    whilePerforming: (tester) async {
      // Navigate to Store tab via stable Key.
      await tester.tap(find.byKey(const Key('nav:dest:store')));
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 40));
      }
      expect(find.byKey(const Key('store:button')), findsOneWidget);
    },
  );
}
