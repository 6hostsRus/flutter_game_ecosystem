import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper to make golden tests deterministic across CI and local.
Future<void> prepareGoldenTest(WidgetTester tester) async {
  // The repository master goldens were captured at DPR=3.0 (1200x2400 for a
  // 400x800 logical surface). Match that here so the test image pixel
  // dimensions line up with the checked-in baselines.
  tester.binding.window.devicePixelRatioTestValue = 3.0;

  // Provide a small settle so async providers and font loaders finish.
  await tester.pumpAndSettle(const Duration(milliseconds: 200));
}

// --- Font registration/loading helpers ---
// Tests and packages can register font assets (family + asset path) using
// `registerFontAsset`, then call `loadRegisteredFonts()` in `setUpAll` to
// ensure font glyphs are available for golden captures.

final List<_FontEntry> _registeredFonts = [];

class _FontEntry {
  final String family;
  final String assetPath;
  _FontEntry(this.family, this.assetPath);
}

/// Register a font asset to be loaded for golden tests.
/// Example: registerFontAsset('Arcade', 'assets/fonts/Arcade.ttf');
void registerFontAsset(String family, String assetPath) {
  _registeredFonts.add(_FontEntry(family, assetPath));
}

/// Loads all previously registered fonts into the engine so text renders
/// identically in tests and in the golden baselines.
Future<void> loadRegisteredFonts() async {
  for (final f in _registeredFonts) {
  // rootBundle.load returns ByteData; FontLoader.addFont expects a
  // Future<ByteData>, so pass the Future directly.
  final fontFuture = rootBundle.load(f.assetPath);
  final loader = FontLoader(f.family);
  loader.addFont(fontFuture);
  await loader.load();
  }
  // Small delay to ensure font glyphs are ready for rendering.
  await Future<void>.delayed(const Duration(milliseconds: 50));
}

/// Backwards-compatible alias used by existing tests.
Future<void> loadFonts() async => await loadRegisteredFonts();

