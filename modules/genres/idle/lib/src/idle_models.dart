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

  Map<String, Object?> toJson() => {
        'id': id,
        'level': level,
        'baseRatePerSec': baseRatePerSec,
        'multiplier': multiplier,
        'unlocked': unlocked,
      };

  static Generator fromJson(Map<String, Object?> json) {
    return Generator(
      id: json['id'] as String,
      level: (json['level'] as num?)?.toInt() ?? 0,
      baseRatePerSec: (json['baseRatePerSec'] as num?)?.toDouble() ?? 0.0,
      multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1.0,
      // unlocked defaults to false if missing
      // ignore: avoid_bool_literals_in_conditional_expressions
      unlocked: json['unlocked'] is bool ? json['unlocked'] as bool : false,
    );
  }
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

  Map<String, Object?> toJson() => {
        'lastSeen': lastSeen.toIso8601String(),
        'softCurrency': softCurrency,
        'prestigePoints': prestigePoints,
        'generators': generators.map((g) => g.toJson()).toList(),
      };

  static IdleState fromJson(Map<String, Object?> json) {
    final gens = (json['generators'] as List?)
            ?.whereType<Map<String, Object?>>()
            .map(Generator.fromJson)
            .toList() ??
        <Generator>[];
    return IdleState(
      lastSeen: DateTime.tryParse((json['lastSeen'] as String?) ?? '') ??
          DateTime.now(),
      softCurrency: (json['softCurrency'] as num?)?.toDouble() ?? 0.0,
      prestigePoints: (json['prestigePoints'] as num?)?.toInt() ?? 0,
      generators: gens,
    );
  }
}

/// ECS-friendly component shapes
class GeneratorComponentData {
  final String id;
  final int level;
  final double ratePerSec;
  final double multiplier;
  final bool unlocked;
  const GeneratorComponentData({
    required this.id,
    required this.level,
    required this.ratePerSec,
    required this.multiplier,
    required this.unlocked,
  });
}

class IdleStateComponentData {
  final int epochMillis;
  final double softCurrency;
  final int prestigePoints;
  const IdleStateComponentData({
    required this.epochMillis,
    required this.softCurrency,
    required this.prestigePoints,
  });
}

extension GeneratorToComponent on Generator {
  GeneratorComponentData toComponent() => GeneratorComponentData(
        id: id,
        level: level,
        ratePerSec: baseRatePerSec,
        multiplier: multiplier,
        unlocked: unlocked,
      );
}

extension IdleStateToComponent on IdleState {
  IdleStateComponentData toComponent() => IdleStateComponentData(
        epochMillis: lastSeen.millisecondsSinceEpoch,
        softCurrency: softCurrency,
        prestigePoints: prestigePoints,
      );
}
