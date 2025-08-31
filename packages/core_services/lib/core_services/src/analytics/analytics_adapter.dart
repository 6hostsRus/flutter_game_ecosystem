import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AnalyticsSink {
  Future<void> track(String event, {Map<String, Object?> props = const {}});
}

class DebugAnalytics implements AnalyticsSink {
  @override
  Future<void> track(String event,
      {Map<String, Object?> props = const {}}) async {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[analytics] $event ${props.isEmpty ? '' : props}');
    }
  }
}

final analyticsProvider = Provider<AnalyticsSink>((_) => DebugAnalytics());
