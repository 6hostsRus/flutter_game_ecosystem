import 'package:demo_game/examples/app_config_idle_example.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';

void main() {
  testWidgets('AppConfig example toggles idle text', (tester) async {
    await tester.pumpWidget(
        const AppConfigIdleExample(config: AppConfig(featureIdle: true)));
    expect(find.textContaining('Idle enabled: true'), findsOneWidget);
    expect(find.text('Idle tab would appear here'), findsOneWidget);

    await tester.pumpWidget(
        const AppConfigIdleExample(config: AppConfig(featureIdle: false)));
    await tester.pumpAndSettle();
    expect(find.textContaining('Idle enabled: false'), findsOneWidget);
    expect(find.text('Idle features are disabled'), findsOneWidget);
  });
}
