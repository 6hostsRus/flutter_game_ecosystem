// ignore_for_file: public_member_api_docs

import 'package:providers/telemetry/telemetry_bus.dart';

/// Basic event hook interface for the board lifecycle.
abstract class BoardEventHook {
  void onSwap(Map<String, dynamic> ctx) {}
  void onMatch(Map<String, dynamic> ctx) {}
  void onCascadeEnd(Map<String, dynamic> ctx) {}
  void onBoardStable(Map<String, dynamic> ctx) {}
}

/// A log sink the app can implement (e.g., forwarding to AnalyticsPort).
abstract class AnalyticsSink {
  void log(String event, Map<String, dynamic> params);
}

/// Hook that relays events to both TelemetryBus (overlay) and an optional AnalyticsSink.
class AnalyticsHook implements BoardEventHook {
  final TelemetryBus telemetry;
  final AnalyticsSink? analytics;
  final Map<String, String> keys; // event key names from config.analytics

  AnalyticsHook({required this.telemetry, required this.keys, this.analytics});

  @override
  void onSwap(Map<String, dynamic> ctx) {
    _emit(keys['on_swap'] ?? 'match.swap', ctx);
  }

  @override
  void onMatch(Map<String, dynamic> ctx) {
    _emit(keys['on_match'] ?? 'match.match', ctx);
  }

  @override
  void onCascadeEnd(Map<String, dynamic> ctx) {
    _emit(keys['on_cascade_end'] ?? 'match.cascade_end', ctx);
  }

  @override
  void onBoardStable(Map<String, dynamic> ctx) {
    _emit(keys['on_board_stable'] ?? 'match.board_stable', ctx);
  }

  void _emit(String evt, Map<String, dynamic> payload) {
    telemetry.emit({'evt': evt, ...payload});
    analytics?.log(evt, payload);
  }
}
