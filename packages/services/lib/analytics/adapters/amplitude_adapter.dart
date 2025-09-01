// library services.analytics.adapters.amplitude_adapter;

// import 'package:services/analytics/analytics_port.dart';
// import 'package:amplitude_flutter/amplitude.dart';
// import 'package:amplitude_flutter/identify.dart' as amp;

// /// Amplitude adapter implementation.
// class AmplitudeAdapter implements AnalyticsPort {
//   final Amplitude _amp;
//   Map<String, Object?> _super = const {};
//   String? _userId;

//   AmplitudeAdapter(Amplitude instance) : _amp = instance;

//   @override
//   void setUser(String? userId, {Map<String, Object?> props = const {}}) {
//     _userId = userId;
//     _amp.setUserId(userId);
//     if (props.isNotEmpty) {
//       final id = amp.Identify();
//       props.forEach((k, v) => id.set(k, v));
//       _amp.identify(id);
//     }
//   }

//   @override
//   void setSuperProps(Map<String, Object?> props) {
//     _super = {..._super, ...props};
//     _amp.setUserProperties(props);
//   }

//   @override
//   void send(AnalyticsEvent event) {
//     final payload = {
//       ..._super,
//       ...event.props,
//       if (_userId != null) 'userId': _userId
//     };
//     _amp.logEvent(event.name, eventProperties: payload);
//   }

//   @override
//   void flush() {
//     // Amplitude queues events; flush is automatic on app lifecycle.
//   }
// }
