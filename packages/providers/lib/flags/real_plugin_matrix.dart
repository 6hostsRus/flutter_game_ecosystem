library providers.flags.real_plugin_matrix;

import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:services/flags/flag_evaluator.dart';
import 'flag_provider.dart';

/// Compile-time env flags (override everything when set)
const bool _envUseRealIap =
    bool.fromEnvironment('USE_REAL_IAP', defaultValue: false);
const bool _envUseRealAds =
    bool.fromEnvironment('USE_REAL_ADS', defaultValue: false);
const bool _envUseRealAnalytics =
    bool.fromEnvironment('USE_REAL_ANALYTICS', defaultValue: false);

class RealPluginMatrix {
  final bool useRealIap;
  final bool useRealAds;
  final bool useRealAnalytics;
  const RealPluginMatrix({
    required this.useRealIap,
    required this.useRealAds,
    required this.useRealAnalytics,
  });

  @override
  String toString() =>
      'RealPluginMatrix(iap=$useRealIap, ads=$useRealAds, analytics=$useRealAnalytics)';
}

/// Exposes the current platform as a lowercase string (ios/android/macos/windows/linux/other).
final platformNameProvider = Provider<String>((ref) {
  if (Platform.isIOS) return 'ios';
  if (Platform.isAndroid) return 'android';
  if (Platform.isMacOS) return 'macos';
  if (Platform.isWindows) return 'windows';
  if (Platform.isLinux) return 'linux';
  return 'other';
});

/// Derives a platform-aware real plugin matrix from flags and env.
final realPluginMatrixProvider = FutureProvider<RealPluginMatrix>((ref) async {
  final eval = await ref.watch(flagEvaluatorProvider.future);
  final platform = ref.watch(platformNameProvider);

  bool flagPlatformOrGlobal(FlagEvaluator e, String base) {
    final p = platform;
    // Prefer platform-specific, then global.
    if (e.isEnabled('${base}_$p')) return true;
    if (e.isEnabled(base)) return true;
    return false;
  }

  final useIap = _envUseRealIap || flagPlatformOrGlobal(eval, 'real_iap');
  final useAds = _envUseRealAds || flagPlatformOrGlobal(eval, 'real_ads');
  final useAnalytics =
      _envUseRealAnalytics || flagPlatformOrGlobal(eval, 'real_analytics');

  return RealPluginMatrix(
    useRealIap: useIap,
    useRealAds: useAds,
    useRealAnalytics: useAnalytics,
  );
});

/// Convenience provider to expose just the IAP toggle (for monetization wiring).
final useRealIapFromMatrixProvider = FutureProvider<bool>((ref) async {
  final m = await ref.watch(realPluginMatrixProvider.future);
  return m.useRealIap;
});

/// Convenience provider to expose Ads real-plugin toggle.
final useRealAdsFromMatrixProvider = FutureProvider<bool>((ref) async {
  final m = await ref.watch(realPluginMatrixProvider.future);
  return m.useRealAds;
});

/// Convenience provider to expose Analytics real-plugin toggle.
final useRealAnalyticsFromMatrixProvider = FutureProvider<bool>((ref) async {
  final m = await ref.watch(realPluginMatrixProvider.future);
  return m.useRealAnalytics;
});
