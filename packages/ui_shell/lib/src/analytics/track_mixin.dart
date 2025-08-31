mixin TrackMixin {
  void track(String event, [Map<String, Object?> props = const {}]) {
    // Hook up to your analytics provider here.
    // Example: Analytics.of(context).track(event, properties: props);
  }
}
