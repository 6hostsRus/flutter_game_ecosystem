library providers.analytics.analytics_provider;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:services/analytics/analytics_port.dart';
import 'package:services/analytics/adapters/debug_logger_adapter.dart';

// Optional adapters (wire up only if you add dependencies).
import 'package:services/analytics/adapters/firebase_analytics_adapter.dart'
    as fb;
import 'package:services/analytics/adapters/amplitude_adapter.dart' as amp;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';

/// Choose analytics sinks by overriding these providers in your app bootstrap.

// Overridable: supply your Amplitude API key (return null to disable).
final amplitudeApiKeyProvider = Provider<String?>((_) => null);

// Optional: override to customize Configuration (serverZone, flushInterval, etc.).
// If provided, its apiKey field will be ignored and replaced with the one from amplitudeApiKeyProvider.
final amplitudeConfigurationOverridesProvider =
    Provider<Configuration?>((_) => null);

/// Provides an Amplitude instance configured per SDK 4 pattern or null if no key.
/// A new instance is created if the API key changes (Riverpod will cache per key).
final amplitudeInstanceProvider = Provider<Amplitude?>((ref) {
  final apiKey = ref.watch(amplitudeApiKeyProvider);
  if (apiKey == null || apiKey.isEmpty) return null;

  final override = ref.watch(amplitudeConfigurationOverridesProvider);
  final config = (override != null)
      ? Configuration(
          apiKey: apiKey,
          serverZone: override.serverZone,
          appVersion: override.appVersion,
          autocapture: override.autocapture,
          useAdvertisingIdForDeviceId: override.useAdvertisingIdForDeviceId,
          flushIntervalMillis: override.flushIntervalMillis,
          useAppSetIdForDeviceId: override.useAppSetIdForDeviceId,
          useBatch: override.useBatch,
          minTimeBetweenSessionsMillis: override.minTimeBetweenSessionsMillis,
          identifyBatchIntervalMillis: override.identifyBatchIntervalMillis,
          cookieOptions: override.cookieOptions,
          enableCoppaControl: override.enableCoppaControl,
          fetchRemoteConfig: override.fetchRemoteConfig,
          flushEventsOnClose: override.flushEventsOnClose,
          defaultTracking: override.defaultTracking,
          deviceId: override.deviceId,
          migrateLegacyData: override.migrateLegacyData,
          flushMaxRetries: override.flushMaxRetries,
          flushQueueSize: override.flushQueueSize,
          identityStorage: override.identityStorage,
          instanceName: override.instanceName,
          minIdLength: override.minIdLength,
          userId: override.userId,
          partnerId: override.partnerId,

          // Add other fields from the `Configuration` class as needed
        )
      : Configuration(apiKey: apiKey);

  return Amplitude(config);
});

/// Debug logger sink (always available).
final debugAnalyticsAdapterProvider =
    Provider<AnalyticsPort>((ref) => DebugLoggerAdapter());

/// Firebase Analytics sink (requires firebase_analytics and Firebase init).
final firebaseAnalyticsAdapterProvider = Provider<AnalyticsPort?>((ref) {
  try {
    final instance = FirebaseAnalytics.instance;
    return fb.FirebaseAnalyticsAdapter(instance);
  } catch (_) {
    return null;
  }
});

/// Amplitude sink (SDK 4 instance).
final amplitudeAnalyticsAdapterProvider = Provider<AnalyticsPort?>((ref) {
  final ampInstance = ref.watch(amplitudeInstanceProvider);
  if (ampInstance == null) return null;
  return amp.AmplitudeAdapter(ampInstance);
});

/// The active AnalyticsPort (defaults to Debug + any optional sinks found).
final analyticsPortProvider = Provider<AnalyticsPort>((ref) {
  final sinks = <AnalyticsPort>[
    ref.read(debugAnalyticsAdapterProvider),
    if (ref.read(firebaseAnalyticsAdapterProvider) != null)
      ref.read(firebaseAnalyticsAdapterProvider)!,
    if (ref.read(amplitudeAnalyticsAdapterProvider) != null)
      ref.read(amplitudeAnalyticsAdapterProvider)!,
  ];
  return MultiAnalytics(sinks);
});
