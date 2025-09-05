import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../lib/main.dart' as demo;

void main() {
  testWidgets('initial deep link builds survivor screen with mode',
      (tester) async {
    await tester
        .pumpWidget(ProviderScope(child: demo.App(initialRoute: '/play/hard')));
    await tester.pumpAndSettle();
    expect(find.text('Survivor'), findsOneWidget);
    expect(find.textContaining('Mode: hard'), findsOneWidget);
  });

  testWidgets('pushNamed deep link navigates to survivor mode variant',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: demo.App()));
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(MaterialApp));
    Navigator.of(context).pushNamed('/play/easy');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Survivor'), findsOneWidget);
    expect(find.textContaining('Mode: easy'), findsOneWidget);
  });
}
