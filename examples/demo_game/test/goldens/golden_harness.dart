// Thin wrapper that prefers Alchemist harness when available, otherwise
// falls back to a testWidgets + matchesGoldenFile approach so tests remain
// runnable across environments.
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:alchemist/alchemist.dart' as alchemist;
import 'dart:io' as io;

// Detect CI-mode via a dart-define set when running tests, e.g.
// `--dart-define=alchemist.platform=ci`. We avoid adding a package-level
// test config because that can interfere with test discovery in some
// flutter/test runner versions.
const String _alchemistPlatform =
    String.fromEnvironment('alchemist.platform', defaultValue: '');
bool get runningOnCi => _alchemistPlatform == 'ci';

// We avoid importing `package:alchemist/alchemist.dart` here directly to keep
// the file compilable even if alchemist is not present; tests can import
// `golden_harness.dart` and call `runGolden` which will use the native
// fallback behavior.

typedef GoldenTestBody = Future<void> Function(WidgetTester tester);

/// Run a golden test with the given `name` by delegating to Alchemist. For
/// compatibility with existing tests we forward the supplied `body` into the
/// `whilePerforming` phase of Alchemist's `goldenTest`. Tests may instead
/// prefer calling `runGoldenAlchemist` directly with a `fileName` and
/// `builder` to avoid ambiguous file resolution.
Future<void> runGolden(String name, GoldenTestBody body) async {
  final inferredFileName = name.replaceAll(' ', '_').toLowerCase();

  alchemist.goldenTest(
    name,
    fileName: inferredFileName,
    builder: () => const SizedBox.shrink(),
    whilePerforming: (tester) async {
      await body(tester);
    },
  );
}

/// A helper for tests that want to provide a proper `builder` and
/// `fileName` explicitly. Prefer this for new Alchemist-style tests.
Future<void> runGoldenAlchemist({
  required String name,
  required String fileName,
  required ValueGetter<Widget> builder,
  alchemist.PumpAction? pumpBeforeTest,
  alchemist.Interaction? whilePerforming,
}) async {
  // Temporary safe fallback: run a native testWidgets + matchesGoldenFile.
  // We do this while debugging Alchemist integration so CI/local runs stay
  // stable. Tests should pass identically to the prior harness behavior.
  testWidgets(name, (WidgetTester tester) async {
    // Apply deterministic surface size and DPR.
    await tester.binding.setSurfaceSize(const Size(400, 800));
    // Use the WidgetTester's view API instead of the deprecated `window`.
    tester.view.devicePixelRatio = 3.0;

    // Pump the widget under a MediaQuery with the expected logical size so
    // layout sees the correct constraints. Wrap the top-level child with a
    // unique key so the golden finder is unambiguous.
    const goldenKey = ValueKey('__golden_root__');
    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(400, 800)),
      child: KeyedSubtree(
        key: goldenKey,
        child: builder(),
      ),
    ));

    // Allow async setup (providers, fonts) to settle.
    await tester.pumpAndSettle(const Duration(milliseconds: 200));

    // Run any test interactions supplied by the caller.
    if (whilePerforming != null) {
      await whilePerforming(tester);
    }

    // Compare against the checked-in golden files. We support three cases:
    //  - Only a platform golden exists (e.g. `home_screen.png`) -> compare it
    //  - Only a CI golden exists (e.g. `home_screen_ci.png`) -> compare it
    //  - Both exist -> compare both (platform first, then CI) so CI and local
    //    developer regressions are both caught.
    // Paths are resolved relative to the test file location. From
    // `examples/demo_game/test/goldens/...` the checked-in baselines live in
    // `../../goldens/` (i.e. `examples/demo_game/goldens`). Use that
    // relative path so `matchesGoldenFile` can locate them correctly.
    // Resolve absolute paths against the test run's working directory
    // (Uri.base). This ensures existence checks and matchesGoldenFile use
    // identical targets regardless of where the test runner sets its cwd.
    final packageRoot = Uri.base.toFilePath();
    final platformPath = '$packageRoot/goldens/$fileName.png';
    final ciPath = '$packageRoot/goldens/${fileName}_ci.png';
    final platformExists = io.File(platformPath).existsSync();
    final ciExists = io.File(ciPath).existsSync();

    if (runningOnCi) {
      // On CI we prefer the CI-specific baseline only. This avoids
      // platform-specific baselines (captured on developer machines)
      // causing spurious diffs when run on the CI runner.
      if (ciExists) {
        await expectLater(find.byKey(const ValueKey('__golden_root__')),
            matchesGoldenFile(ciPath));
      } else if (platformExists) {
        // Fall back to platform baseline if no CI-specific file exists.
        await expectLater(find.byKey(const ValueKey('__golden_root__')),
            matchesGoldenFile(platformPath));
      } else {
        // No baseline present — let the test fail with a clear message.
        throw StateError('No golden baseline found for $fileName');
      }
    } else {
      // Local/developer runs: compare platform baseline first (developer
      // expectation) and also compare CI baseline if present so local
      // developers catch CI regressions early.
      if (platformExists) {
        await expectLater(find.byKey(const ValueKey('__golden_root__')),
            matchesGoldenFile(platformPath));
      }
      if (ciExists) {
        await expectLater(find.byKey(const ValueKey('__golden_root__')),
            matchesGoldenFile(ciPath));
      }
      if (!platformExists && !ciExists) {
        throw StateError('No golden baseline found for $fileName');
      }
    }
  });
}
