import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/flags/flag_provider.dart';
import 'package:services/flags/remote_overrides.dart';
import 'package:providers/flags/real_plugin_matrix.dart';

class _InlineOverrides implements FlagOverridesSource {
  final Map<String, dynamic> data;
  _InlineOverrides(this.data);
  Future<Map<String, dynamic>> fetch() async => data;
}

void main() {
  test('platform-specific overrides take precedence', () async {
    final container = ProviderContainer(overrides: [
      // Base local flags empty → feed via overrides instead of asset IO
      flagOverridesSourceProvider.overrideWithValue(
        _InlineOverrides({
          'real_iap': false,
          'real_iap_android': true,
        }),
      ),
      platformNameProvider.overrideWithValue('android'),
    ]);
    addTearDown(container.dispose);
    final matrix = await container.read(realPluginMatrixProvider.future);
    expect(matrix.useRealIap, true, reason: 'android-specific flag should win');
  });

  test('global flag applies when platform-specific absent', () async {
    final container = ProviderContainer(overrides: [
      flagOverridesSourceProvider.overrideWithValue(
        _InlineOverrides({
          'real_ads': true,
        }),
      ),
      platformNameProvider.overrideWithValue('ios'),
    ]);
    addTearDown(container.dispose);
    final matrix = await container.read(realPluginMatrixProvider.future);
    expect(matrix.useRealAds, true);
  });

  test('defaults false when flags missing', () async {
    final container = ProviderContainer(overrides: [
      flagOverridesSourceProvider.overrideWithValue(_InlineOverrides({})),
      platformNameProvider.overrideWithValue('ios'),
    ]);
    addTearDown(container.dispose);
    final matrix = await container.read(realPluginMatrixProvider.future);
    expect(matrix.useRealIap, false);
    expect(matrix.useRealAds, false);
    expect(matrix.useRealAnalytics, false);
  });
}
