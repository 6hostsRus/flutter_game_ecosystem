library services.analytics.adapters.debug_logger_adapter;

import 'dart:developer' as dev;

import 'package:services/analytics/analytics_port.dart';

/// Simple console logger analytics adapter.
///
/// Useful as a default / fallback sink during development and tests.
/// It keeps local copies of user + super props (similar pattern to the
/// other adapters) and merges them at send time. `MultiAnalytics` already
/// performs a merge, but the extra merge here keeps the adapter usable
/// standalone as well.
class DebugLoggerAdapter implements AnalyticsPort {
  Map<String, Object?> _super = const {};
  String? _userId;

  void _log(String stage, Object? details) {
    // Use developer.log so tools can filter by the 'analytics' category.
    dev.log('[' + stage + '] ' + (details?.toString() ?? ''),
        name: 'analytics');
  }

  @override
  void setUser(String? userId, {Map<String, Object?> props = const {}}) {
    _userId = userId;
    _log('user', {'id': userId, if (props.isNotEmpty) 'props': props});
  }

  @override
  void setSuperProps(Map<String, Object?> props) {
    _super = {..._super, ...props};
    _log('super', _super);
  }

  @override
  void send(AnalyticsEvent event) {
    final merged = {
      ..._super,
      ...event.props,
      if (_userId != null) 'userId': _userId,
    };
    _log('event', {'name': event.name, 'props': merged});
  }

  @override
  void flush() {
    _log('flush', null);
  }
}
