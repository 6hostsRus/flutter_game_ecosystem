import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo_game/main.dart' as demo;
import 'golden_test_helper.dart';
import 'golden_harness.dart';

void main() {
  setUpAll(() async {
    // register demo-specific fonts here if you have bundled fonts, e.g.
    // registerFontAsset('Arcade', 'assets/fonts/Arcade.ttf');
    await loadFonts();
  });

  // Migrate to Alchemist-style golden test.
  runGoldenAlchemist(
    name: 'HomeScreen golden',
    fileName: 'home_screen',
    builder: () => const ProviderScope(child: demo.App()),
    pumpBeforeTest: (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await prepareGoldenTest(tester);
    },
    whilePerforming: (tester) async {
      expect(find.textContaining('Home'), findsWidgets);
    },
  );
}
