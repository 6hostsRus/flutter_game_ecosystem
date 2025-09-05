import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../lib/main.dart' as demo;

void main() {
  testWidgets('HomeScreen golden', (tester) async {
    const width = 400.0;
    const height = 800.0;
    await tester.binding.setSurfaceSize(const Size(width, height));

    await tester.pumpWidget(const ProviderScope(child: demo.App()));
    await tester.pump();

    // Ensure expected primary text present before capturing.
    expect(find.textContaining('Home'), findsWidgets);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../goldens/home_screen.png'),
    );
  });
}
