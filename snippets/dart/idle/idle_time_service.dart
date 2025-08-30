
class IdleTimeService {
  double computeOfflineYield(DateTime lastSeen, double totalRatePerSec, {double capSeconds=8*3600}){
    final now = DateTime.now(); final delta = now.difference(lastSeen).inSeconds.toDouble();
    final clamped = delta.clamp(0, capSeconds); return clamped * totalRatePerSec;
  }
}
