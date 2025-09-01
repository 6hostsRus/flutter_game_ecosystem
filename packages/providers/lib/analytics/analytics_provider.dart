library providers.analytics.analytics_provider;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:services/analytics/analytics_port.dart';
import 'package:services/analytics/adapters/debug_logger_adapter.dart';

// Optional adapters (wire up only if you add dependencies).
import 'package:services/analytics/adapters/firebase_analytics_adapter.dart' as fb;
import 'package:services/analytics/adapters/amplitude_adapter.dart' as amp;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:amplitude_flutter/amplitude.dart';

/// Choose analytics sinks by overriding these providers in your app bootstrap.

/// Debug logger sink (always available).
final debugAnalyticsAdapterProvider = Provider<AnalyticsPort>((ref) => DebugLoggerAdapter());

/// Firebase Analytics sink (requires firebase_analytics and Firebase init).
final firebaseAnalyticsAdapterProvider = Provider<AnalyticsPort?>((ref) {
  try {
    final instance = FirebaseAnalytics.instance;
    return fb.FirebaseAnalyticsAdapter(instance);
  } catch (_) {
    return null;
  }
});

/// Amplitude sink (requires amplitude_flutter with an API key initialized by you).
final amplitudeAnalyticsAdapterProvider = Provider<AnalyticsPort?>((ref) {
  try {
    final ampClient = Amplitude.getInstance(instanceName: 'default');
    // IMPORTANT: You must call ampClient.init('YOUR_API_KEY') in your app init.
    return amp.AmplitudeAdapter(ampClient);
  } catch (_) {
    return null;
  }
});

/// The active AnalyticsPort (defaults to Debug + any optional sinks found).
final analyticsPortProvider = Provider<AnalyticsPort>((ref) {
  final sinks = <AnalyticsPort>[
    ref.read(debugAnalyticsAdapterProvider),
    if (ref.read(firebaseAnalyticsAdapterProvider) != null) ref.read(firebaseAnalyticsAdapterProvider)!,
    if (ref.read(amplitudeAnalyticsAdapterProvider) != null) ref.read(amplitudeAnalyticsAdapterProvider)!,
  ];
  return MultiAnalytics(sinks);
});
