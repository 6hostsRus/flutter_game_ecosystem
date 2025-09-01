library services.flags.remote_overrides;

import 'dart:convert';
import 'dart:io';

/// Abstract source for remote flag overrides.
abstract class FlagOverridesSource {
  /// Fetches JSON overrides (map of flagName -> rule).
  Future<Map<String, dynamic>> fetch();
}

/// Simple HTTP JSON source. Expects application/json returning a JSON object.
class HttpJsonOverridesSource implements FlagOverridesSource {
  final Uri url;
  final Map<String, String> headers;
  HttpJsonOverridesSource(String url, {Map<String, String>? headers})
      : url = Uri.parse(url),
        headers = headers ?? const {};

  @override
  Future<Map<String, dynamic>> fetch() async {
    final client = HttpClient();
    try {
      final req = await client.getUrl(url);
      headers.forEach((k, v) => req.headers.set(k, v));
      final res = await req.close();
      if (res.statusCode != 200) {
        return {};
      }
      final body = await res.transform(utf8.decoder).join();
      final data = json.decode(body);
      if (data is Map<String, dynamic>) return data;
      return {};
    } finally {
      client.close();
    }
  }
}

/// Firebase Remote Config source (optional dependency).
///
/// To use:
///   - Add dependency: firebase_remote_config
///   - Initialize Firebase in your app before calling fetch().
///   - Ensure you set a JSON string parameter key [paramKey].
class FirebaseRemoteConfigOverridesSource implements FlagOverridesSource {
  final String paramKey;
  final Duration fetchTimeout;
  final Duration minimumFetchInterval;

  FirebaseRemoteConfigOverridesSource(
    this.paramKey, {
    this.fetchTimeout = const Duration(seconds: 10),
    this.minimumFetchInterval = const Duration(minutes: 5),
  });

  @override
  Future<Map<String, dynamic>> fetch() async {
    // Lazy import pattern: avoid hard dependency at compile time if not used.
    try {
      // ignore: avoid_dynamic_calls
      final remoteConfigLib = await Future.value(null);
    } catch (_) {}
    // The following code assumes firebase_remote_config is added to the app.
    // Replace with direct imports when integrating.
    try {
      // dynamic import shim
      final remote_config = await _remoteConfigInstance();
      await remote_config.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: fetchTimeout,
        minimumFetchInterval: minimumFetchInterval,
      ));
      await remote_config.fetchAndActivate();
      final raw = remote_config.getString(paramKey);
      if (raw.isEmpty) return {};
      final data = json.decode(raw);
      if (data is Map<String, dynamic>) return data;
      return {};
    } catch (_) {
      return {};
    }
  }
}

/// Below is a minimal interface mask to keep this file self-contained for now.
/// In your project, replace this shim with:
///   import 'package:firebase_remote_config/firebase_remote_config.dart';
/// and delete the shim.
class RemoteConfigSettings {
  final Duration fetchTimeout;
  final Duration minimumFetchInterval;
  RemoteConfigSettings({required this.fetchTimeout, required this.minimumFetchInterval});
}

/// shim methods: you should import the real package in your app and delete these.
Future<_RemoteConfigShim> _remoteConfigInstance() async => _RemoteConfigShim();

class _RemoteConfigShim {
  Future<void> setConfigSettings(RemoteConfigSettings _) async {}
  Future<bool> fetchAndActivate() async => true;
  String getString(String key) => '{}';
}
