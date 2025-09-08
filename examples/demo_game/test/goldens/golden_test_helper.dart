import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

/// Helper to make golden tests deterministic across CI and local.
Future<void> prepareGoldenTest(WidgetTester tester) async {
  // Fix device pixel ratio to avoid DPR rounding diffs.
  tester.binding.window.devicePixelRatioTestValue = 1.0;

  // Provide a small settle so async providers and font loaders finish.
  await tester.pumpAndSettle(const Duration(milliseconds: 200));
}

Future<void> loadFonts() async {
  // If you bundle fonts, load them here using loadAppFonts from golden_toolkit
  await loadAppFonts();
}
