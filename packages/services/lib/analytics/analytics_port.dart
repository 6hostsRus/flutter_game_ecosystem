library services.analytics.analytics_port;

/// A normalized analytics event.
class AnalyticsEvent {
  final String name;
  final Map<String, Object?> props;
  const AnalyticsEvent(this.name, [this.props = const {}]);

  @override
  String toString() =>
      'AnalyticsEvent(name: ' + name + ', props: ' + props.toString() + ')';
}

/// Public sink interface for analytics events.
abstract class AnalyticsPort {
  /// Identify / update the current user.
  void setUser(String? userId, {Map<String, Object?> props = const {}});

  /// Merge super properties that will be attached to all subsequent events.
  void setSuperProps(Map<String, Object?> props);

  /// Send a single event.
  void send(AnalyticsEvent event);

  /// Flush event buffers (if any).
  void flush();
}

/// A simple multi-adapter that fans out to multiple sinks.
class MultiAnalytics implements AnalyticsPort {
  final List<AnalyticsPort> _sinks;
  Map<String, Object?> _super = const {};
  String? _userId;

  MultiAnalytics(this._sinks);

  @override
  void setUser(String? userId, {Map<String, Object?> props = const {}}) {
    _userId = userId;
    for (final s in _sinks) {
      s.setUser(userId, props: props);
    }
  }

  @override
  void setSuperProps(Map<String, Object?> props) {
    _super = {..._super, ...props};
    for (final s in _sinks) {
      s.setSuperProps(props);
    }
  }

  @override
  void send(AnalyticsEvent event) {
    final merged = AnalyticsEvent(
      event.name,
      {..._super, ...event.props, if (_userId != null) 'userId': _userId},
    );
    for (final s in _sinks) {
      s.send(merged);
    }
  }

  @override
  void flush() {
    for (final s in _sinks) {
      s.flush();
    }
  }
}
