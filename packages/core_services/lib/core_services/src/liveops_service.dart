import 'package:flutter_riverpod/flutter_riverpod.dart';

class LiveOpEvent {
  final String id;
  final String name;
  final DateTime startAt;
  final DateTime endAt;
  final Map<String, double> multipliers; // e.g., {'idle_rate': 2.0}
  const LiveOpEvent(
      {required this.id,
      required this.name,
      required this.startAt,
      required this.endAt,
      this.multipliers = const {}});

  bool get active {
    final now = DateTime.now();
    return now.isAfter(startAt) && now.isBefore(endAt);
  }
}

class LiveOpsService {
  final List<LiveOpEvent> _events;
  LiveOpsService([List<LiveOpEvent>? events]) : _events = events ?? [];

  List<LiveOpEvent> get activeEvents => _events.where((e) => e.active).toList();

  double multiplierFor(String key) {
    double m = 1.0;
    for (final e in activeEvents) {
      if (e.multipliers.containsKey(key)) {
        m *= e.multipliers[key]!;
      }
    }
    return m;
  }
}

final liveOpsProvider = Provider<LiveOpsService>((ref) {
  final now = DateTime.now();
  // Example: weekend double idle rate
  final start =
      DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
  final end = start.add(const Duration(days: 3));
  return LiveOpsService([
    LiveOpEvent(
        id: 'weekend_double_idle',
        name: 'Weekend Double Idle',
        startAt: start,
        endAt: end,
        multipliers: {'idle_rate': 2.0}),
  ]);
});
