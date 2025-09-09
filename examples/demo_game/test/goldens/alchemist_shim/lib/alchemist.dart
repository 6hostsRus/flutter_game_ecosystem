// Minimal shim exposing a tiny subset of Alchemist's API used by our tests.
// This shim intentionally avoids blocked-text capture and delegates to
// `testWidgets` + `expectLater(matchesGoldenFile)` for stability.

library alchemist_shim;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

typedef PumpAction = Future<void> Function(WidgetTester tester);
typedef Interaction = Future<void> Function(WidgetTester tester);

void goldenTest(
  String name, {
  required String fileName,
  required ValueGetter<Widget> builder,
  PumpAction? pumpBeforeTest,
  Interaction? whilePerforming,
}) {
  testWidgets(name, (WidgetTester tester) async {
    // Default environment alignment
    await tester.binding.setSurfaceSize(const Size(400, 800));
    // Use the WidgetTester's view API instead of the deprecated `window`.
    tester.view.devicePixelRatio = 3.0;

    // Pump the widget under a keyed subtree so the golden finder is exact.
    const goldenKey = ValueKey('__golden_root__');
    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(400, 800)),
      child: KeyedSubtree(key: goldenKey, child: builder()),
    ));

    if (pumpBeforeTest != null) {
      await pumpBeforeTest(tester);
    } else {
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
    }

    if (whilePerforming != null) {
      await whilePerforming(tester);
    }

    await expectLater(find.byKey(const ValueKey('__golden_root__')),
        matchesGoldenFile('../../goldens/$fileName.png'));
  });
}
