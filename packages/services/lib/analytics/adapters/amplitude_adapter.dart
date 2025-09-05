library services.analytics.adapters.amplitude_adapter;

import 'package:amplitude_flutter/events/base_event.dart';
import 'package:amplitude_flutter/events/identify.dart';
import 'package:services/analytics/analytics_port.dart';
import 'package:amplitude_flutter/amplitude.dart';

/// Amplitude adapter implementation.
class AmplitudeAdapter implements AnalyticsPort {
  final Amplitude _amp;
  Map<String, Object?> _super = const {};
  String? _userId;

  AmplitudeAdapter(Amplitude instance) : _amp = instance;

  @override
  void setUser(String? userId, {Map<String, Object?> props = const {}}) {
    _userId = userId;
    _amp.setUserId(_userId ?? userId);
    if (props.isNotEmpty) {
      final id = Identify();
      props.forEach((k, v) => id.set(k, v));
      _amp.identify(id);
    }
  }

  @override
  void setSuperProps(Map<String, Object?> props) {
    _super = {..._super, ...props};
  }

  @override
  void send(AnalyticsEvent event) {
    final payload = {
      ..._super,
      ...event.props,
      // userId is automatically associated; do not duplicate in eventProperties.
    };
    _amp.track(BaseEvent(event.name, eventProperties: payload));
  }

  @override
  void flush() {
    // Explicit flush (SDK 4 provides flush()).
    try {
      _amp.flush();
    } catch (_) {
      // Silently ignore if not supported.
    }
  }
}
