import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_services/core_services.dart';
import 'package:demo_game/main.dart' as demo;
import 'golden_test_helper.dart';
import 'golden_harness.dart';

void main() {
  setUpAll(() async {
    // registerFontAsset('Arcade', 'assets/fonts/Arcade.ttf');
    await loadFonts();
  });

  runGoldenAlchemist(
    name: 'HomeScreen rich state golden',
    fileName: 'home_screen_rich',
    builder: () {
      final container = ProviderContainer(overrides: [
        walletProvider.overrideWith((ref) {
          final notifier = WalletNotifier();
          notifier.setState(const WalletState(coins: 1234, premium: 42));
          return notifier;
        }),
      ]);
      return UncontrolledProviderScope(container: container, child: const demo.App());
    },
    pumpBeforeTest: (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await prepareGoldenTest(tester);
    },
    whilePerforming: (tester) async {
      expect(find.textContaining('Home'), findsWidgets);
      expect(find.text('1234'), findsOneWidget);
    },
  );
}
