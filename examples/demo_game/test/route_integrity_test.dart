import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../lib/main.dart' as demo;

void main() {
  testWidgets('App builds with navigation scaffold & Home visible',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: demo.App()));
    await tester.pump();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.textContaining('Home'), findsWidgets);
  });
}
