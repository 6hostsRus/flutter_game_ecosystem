import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_services/core_services.dart';
import 'package:demo_game/main.dart' as demo;
import 'golden_test_helper.dart';

void main() {
  testWidgets('HomeScreen rich state golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    final container = ProviderContainer(overrides: [
      walletProvider.overrideWith((ref) {
        final notifier = WalletNotifier();
        notifier.setState(const WalletState(coins: 1234, premium: 42));
        return notifier;
      }),
    ]);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const demo.App(),
    ));
  await loadFonts();
  await prepareGoldenTest(tester);
    expect(find.textContaining('Home'), findsWidgets);
    expect(find.text('1234'), findsOneWidget);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../goldens/home_screen_rich.png'),
    );
  });
}
