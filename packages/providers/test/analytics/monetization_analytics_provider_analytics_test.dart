import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/analytics/analytics_provider.dart';
import 'package:providers/analytics/analytics_hooks.dart';
import 'package:services/monetization/gateway_port.dart';
import 'package:services/analytics/analytics_port.dart';

class CollectSink implements AnalyticsPort {
  final events = <String, Map<String, Object?>>{};
  @override
  void flush() {}
  @override
  void send(AnalyticsEvent event) {
    events[event.name] = event.props;
    final log = File('build/metrics/analytics_events.ndjson');
    log.parent.createSync(recursive: true);
    log.writeAsStringSync('{"event":"${event.name}","props":${event.props}}\n',
        mode: FileMode.append);
  }

  @override
  void setSuperProps(Map<String, Object?> props) {}
  @override
  void setUser(String? userId, {Map<String, Object?> props = const {}}) {}
}

void main() {
  test('analyticsMonetizationGatewayProvider emits purchase_success', () async {
    final sink = CollectSink();
    final container = ProviderContainer(overrides: [
      analyticsPortProvider.overrideWithValue(sink),
    ]);
    final decorated = container.read(analyticsMonetizationGatewayProvider);
    final skus = await decorated.listSkus();
    expect(skus.isNotEmpty, true);
    await decorated.checkout(const CheckoutRequest(skuId: 'pack.starter.001'));
    expect(sink.events.containsKey('purchase_success'), true);
  });
}
