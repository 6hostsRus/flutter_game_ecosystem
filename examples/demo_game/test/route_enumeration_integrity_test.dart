import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_game/main.dart' as demo;

// Contract: enumerate known routes from the spec and assert navigation works.
// - Tabs: switch each destination and verify widget runtimeType matches spec widget name.
// - Deep links: push example routes and verify resulting widget type is expected.
void main() {
  // Helper to avoid indefinite pumpAndSettle hangs from long-running animations.
  Future<void> settleLimited(WidgetTester tester, {int maxFrames = 120}) async {
    for (var i = 0; i < maxFrames; i++) {
      // transientCallbackCount == 0 means no pending animations/schedules.
      if (tester.binding.transientCallbackCount == 0) break;
      await tester.pump(const Duration(milliseconds: 16));
    }
  }

  testWidgets('route registry enumeration integrity', (tester) async {
    // Load route registry spec (relative to examples/demo_game).
    final specFile = File('../../tools/route_spec/route_registry.json');
    expect(specFile.existsSync(), true, reason: 'Missing route registry spec');
    final spec =
        jsonDecode(specFile.readAsStringSync()) as Map<String, dynamic>;
    final tabs = (spec['tabs'] as List).cast<Map>().toList();
    final deepLinks = (spec['deep_links'] as List).cast<Map>().toList();

    await tester.pumpWidget(const ProviderScope(child: demo.App()));
    await settleLimited(tester);

    // Verify NavigationBar exists.
    expect(find.byType(NavigationBar), findsOneWidget);

    // Enumerate tabs: tap each NavigationDestination and assert widget name matches.
    final destinations = find.byType(NavigationDestination);
    expect(destinations, findsNWidgets(tabs.length));
    for (int i = 0; i < tabs.length; i++) {
      await tester.tap(destinations.at(i));
      await settleLimited(tester);

      final expectedWidgetName = (tabs[i]['widget'] as String);
      // Match using runtimeType.toString() to avoid hardcoding Types here.
      final matcher = find.byWidgetPredicate(
        (w) => w.runtimeType.toString() == expectedWidgetName,
        description: 'widget $expectedWidgetName',
      );
      expect(matcher, findsWidgets,
          reason: 'Tab[$i] did not show $expectedWidgetName');

      // Stronger assertion: screen-specific text cue per tab.
      Finder textCue;
      switch (expectedWidgetName) {
        case 'HomeScreen':
          textCue = find.textContaining('Home');
          break;
        case 'UpgradesScreen':
          textCue = find.text('Double Income');
          break;
        case 'ItemsScreen':
          textCue = find.text('Iron Sword');
          break;
        case 'StoreScreen':
          textCue = find.text('Open Store');
          break;
        case 'QuestsScreen':
          textCue = find.text('Log in');
          break;
        default:
          textCue = find.byType(NavigationBar); // fallback sanity
      }
      expect(textCue, findsWidgets,
          reason: 'Tab[$i] missing expected content for $expectedWidgetName');
    }

    // Deep link examples: push and validate expected screen type (where known).
    final ctx = tester.element(find.byType(NavigationBar));
    for (final dl in deepLinks) {
      final example = (dl['deeplink_example'] ?? '').toString();
      if (example.isEmpty) continue;
      Navigator.of(ctx).pushNamed(example);
      await settleLimited(tester);

      // Map known modal route ids to expected widget Types.
      final mapsTo = dl['maps_to']?.toString();
      if (mapsTo == 'modal:survivor') {
        expect(find.byType(demo.SurvivorScreen), findsOneWidget,
            reason: 'Deep link $example should render SurvivorScreen');
        expect(find.text('Survivor'), findsOneWidget,
            reason: 'App bar title should be present');
        expect(find.textContaining('Mode:'), findsOneWidget,
            reason: 'Mode label should be present');
      }

      // Pop back to home for the next deep link.
      Navigator.of(ctx).pop();
      await settleLimited(tester);
    }
  });

  testWidgets('unknown route via pushNamed falls back to HomeScreen',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: demo.App()));
    await settleLimited(tester);

    expect(find.byType(NavigationBar), findsOneWidget);

    // Use NavigatorState instead of Element context to ensure a Navigator is available.
    final navCtx = tester.element(find.byType(NavigationBar));
    Navigator.of(navCtx).pushNamed('/this/does/not/exist');
    await settleLimited(tester);

    expect(find.byType(NavigationBar), findsOneWidget,
        reason: 'Fallback should render main scaffold with NavigationBar');
    expect(find.textContaining('Home'), findsWidgets,
        reason: 'Fallback should land on HomeScreen or equivalent');

    // Pop pushed fallback route so test doesn't hang waiting on route future.
    Navigator.of(navCtx).pop();
    await settleLimited(tester);
  });

  testWidgets('unknown initialRoute falls back to HomeScreen', (tester) async {
    await tester.pumpWidget(
        const ProviderScope(child: demo.App(initialRoute: '/nope')));
    await settleLimited(tester);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.textContaining('Home'), findsWidgets);
  });
}
