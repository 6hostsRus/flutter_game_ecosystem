import '../core/clock.dart';

class IdleTimeService {
  final Clock clock;
  IdleTimeService({Clock? clock}) : clock = clock ?? const SystemClock();

  double computeOfflineYield(
    DateTime lastSeen,
    double totalRatePerSec, {
    double capSeconds = 8 * 3600,
  }) {
    final now = DateTime.fromMillisecondsSinceEpoch(clock.nowMillis());
    final delta = now.difference(lastSeen).inSeconds.toDouble();
    final clamped = delta.clamp(0, capSeconds);
    return clamped * totalRatePerSec;
  }
}
