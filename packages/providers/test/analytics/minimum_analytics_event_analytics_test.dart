import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/analytics/analytics_provider.dart';
import 'package:services/analytics/analytics_port.dart';
import 'package:services/analytics/testing.dart';

/// A tiny sink that writes NDJSON lines for observed events.
class _NdjsonSink implements AnalyticsPort {
  @override
  void send(AnalyticsEvent event) {
    final line = '{"event":"${event.name}","props":${event.props}}\n';
    appendAnalyticsNdjsonLine(line);
  }

  @override
  void flush() {}

  @override
  void setSuperProps(Map<String, Object?> props) {}

  @override
  void setUser(String? userId, {Map<String, Object?> props = const {}}) {}
}

void main() {
  test('logs at least one analytics event to ndjson', () async {
    final sink = _NdjsonSink();
    final container = ProviderContainer(overrides: [
      analyticsPortProvider.overrideWithValue(sink),
    ]);
    addTearDown(container.dispose);

    final port = container.read(analyticsPortProvider);
    port.send(const AnalyticsEvent('minimum_analytics_event', {
      'source': 'providers_min_test',
    }));

    // Verify file exists with at least one line.
    final outFile = File('build/metrics/analytics_events.ndjson');
    expect(outFile.existsSync(), true);
    final lines = outFile.readAsLinesSync();
    expect(lines.isNotEmpty, true);
  });
}
