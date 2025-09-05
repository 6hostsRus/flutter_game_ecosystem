import 'package:services/analytics/analytics_port.dart';

class FakeAnalyticsSink implements AnalyticsPort {
  final List<AnalyticsEvent> events = [];
  final Map<String, Object?> superProps = {};
  String? userId;

  @override
  void flush() {}

  @override
  void send(AnalyticsEvent event) {
    events.add(event);
  }

  @override
  void setSuperProps(Map<String, Object?> props) {
    superProps.addAll(props);
  }

  @override
  void setUser(String? userId, {Map<String, Object?> props = const {}}) {
    this.userId = userId;
    if (props.isNotEmpty) superProps.addAll(props);
  }
}
