import 'package:core_services/analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsSink implements AnalyticsSink {
  final FirebaseAnalytics _fa;
  FirebaseAnalyticsSink(this._fa);

  @override
  Future<void> track(String event,
      {Map<String, Object?> props = const {}}) async {
    await _fa.logEvent(
        name: event,
        parameters: props.map((k, v) => MapEntry(
            k, v is num || v is String || v is bool ? v : v.toString())));
  }
}
