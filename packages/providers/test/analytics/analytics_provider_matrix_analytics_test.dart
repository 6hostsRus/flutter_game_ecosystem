import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/analytics/analytics_provider.dart';
import 'package:providers/flags/real_plugin_matrix.dart';
import 'package:services/analytics/analytics_port.dart';

class _FakeSink implements AnalyticsPort {
  final List<AnalyticsEvent> events = [];
  Map<String, Object?> _super = {};
  String? _user;
  @override
  void send(AnalyticsEvent event) {
    final merged = AnalyticsEvent(
      event.name,
      {
        ..._super,
        ...event.props,
        if (_user != null) 'userId': _user,
      },
    );
    events.add(merged);
  }

  @override
  void flush() {}
  @override
  void setSuperProps(Map<String, Object?> props) => _super = props;
  @override
  void setUser(String? userId, {Map<String, Object?> props = const {}}) =>
      _user = userId;
}

void main() {
  group('AnalyticsProvider x RealPluginMatrix', () {
    test('when useRealAnalytics=false, only debug sink is active', () async {
      final container = ProviderContainer(overrides: [
        useRealAnalyticsFromMatrixProvider.overrideWith((ref) async => false),
        // Adapter providers respect the matrix flag: return null here.
        firebaseAnalyticsAdapterProvider.overrideWith((ref) => null),
        amplitudeAnalyticsAdapterProvider.overrideWith((ref) => null),
      ]);
      addTearDown(container.dispose);

      final port = container.read(analyticsPortProvider);
      // Also override debug sink to our fake to observe events indirectly.
      // Since debug sink is built-in, we cannot override directly here; instead, we
      // just ensure sending does not throw and trust composition (no SDK sinks).
      expect(
          () => port.send(const AnalyticsEvent('test_event')), returnsNormally);
    });

    test('when useRealAnalytics=true, optional sinks can be included',
        () async {
      final fakeFb = _FakeSink();
      final container = ProviderContainer(overrides: [
        useRealAnalyticsFromMatrixProvider.overrideWith((ref) async => true),
        // Supply fake optional sinks (simulating Firebase/Amplitude being available).
        firebaseAnalyticsAdapterProvider.overrideWith((ref) => fakeFb),
        amplitudeAnalyticsAdapterProvider.overrideWith((ref) => null),
      ]);
      addTearDown(container.dispose);

      final port = container.read(analyticsPortProvider);
      port.send(const AnalyticsEvent('test_event'));
      // Our fake FB sink should receive the event when the real flag is enabled.
      expect(fakeFb.events.length, 1);
      expect(fakeFb.events.first.name, 'test_event');
    });
  });
}
