library services.analytics.adapters.firebase_analytics_adapter;

import 'package:services/analytics/analytics_port.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Firebase Analytics adapter implementation.
class FirebaseAnalyticsAdapter implements AnalyticsPort {
  final FirebaseAnalytics _fa;
  Map<String, Object?> _super = const {};
  String? _userId;

  FirebaseAnalyticsAdapter(FirebaseAnalytics instance) : _fa = instance;

  @override
  void setUser(String? userId, {Map<String, Object?> props = const {}}) {
    _userId = userId;
    // Firebase uses setUserId + setUserProperty (one at a time).
    _fa.setUserId(id: userId);
    props.forEach((k, v) => _fa.setUserProperty(name: k, value: v?.toString()));
  }

  @override
  void setSuperProps(Map<String, Object?> props) {
    _super = {..._super, ...props};
    // Firebase has no global super props API; we merge at send time.
  }

  @override
  void send(AnalyticsEvent event) {
    final params = <String, Object?>{..._super, ...event.props};
    if (_userId != null) params['userId'] = _userId;
    _fa.logEvent(
        name: event.name,
        parameters: params.map((k, v) => MapEntry(k, v.toString())));
  }

  @override
  void flush() {
    // Firebase SDK batches internally; nothing explicit to flush.
  }
}
