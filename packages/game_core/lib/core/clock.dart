/// Clock abstractions for testable time.
abstract class Clock {
  /// Returns the current time in milliseconds since epoch.
  int nowMillis();
}

extension ClockExtensions on Clock {
  /// Returns the current time as [DateTime].
  DateTime now() => DateTime.fromMillisecondsSinceEpoch(nowMillis());
}

/// System clock that delegates to [DateTime.now].
class SystemClock implements Clock {
  const SystemClock();

  @override
  int nowMillis() => DateTime.now().millisecondsSinceEpoch;
}

/// A fake clock for tests with manual control over time.
class FakeClock implements Clock {
  int _millis;

  FakeClock(int initialMillis) : _millis = initialMillis;

  /// Advances the clock by [deltaMillis].
  void advance(int deltaMillis) {
    _millis += deltaMillis;
  }

  @override
  int nowMillis() => _millis;
}
