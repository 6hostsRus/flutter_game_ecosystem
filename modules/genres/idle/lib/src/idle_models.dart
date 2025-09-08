class Generator {
  final String id;
  int level;
  double baseRatePerSec;
  double multiplier;
  bool unlocked;
  double Function(int level) costCurve;
  Generator({
    required this.id,
    this.level = 0,
    this.baseRatePerSec = 0.0,
    this.multiplier = 1.0,
    this.unlocked = false,
    double Function(int)? costCurve,
  }) : costCurve = costCurve ?? ((int lvl) => 10.0 * (1.15 * lvl));
}

class IdleState {
  DateTime lastSeen;
  double softCurrency;
  int prestigePoints;
  List<Generator> generators;
  IdleState({
    DateTime? lastSeen,
    this.softCurrency = 0.0,
    this.prestigePoints = 0,
    List<Generator>? generators,
  })  : lastSeen = lastSeen ?? DateTime.now(),
        generators = generators ?? [];
}
