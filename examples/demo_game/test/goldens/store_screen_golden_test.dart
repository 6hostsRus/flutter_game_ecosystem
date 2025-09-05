import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../lib/main.dart' as demo;

void main() {
  testWidgets('StoreScreen golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester.pumpWidget(const ProviderScope(child: demo.App()));
    await tester.pump();

    // Navigate to Store tab (index 3) via NavigationBar destinations.
    final destinations = find.byType(NavigationDestination);
    expect(destinations, findsNWidgets(5));
    await tester.tap(destinations.at(3));
    for (int i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 40));
    }
    expect(find.text('Open Store'), findsOneWidget);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../goldens/store_screen.png'),
    );
  });
}
