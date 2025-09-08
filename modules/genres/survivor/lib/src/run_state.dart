/// Survivor-like run state model.
///
/// Tracks elapsed time, wave progression, DPS applied to player, and health.
class SurvivorRunState {
  final int wave;
  final double timeSec;
  final double damagePerSec;
  final double health;

  /// Additional damage growth applied per wave (e.g., 0.1 => +10% DPS each wave).
  final double dpsGrowthPerWave;

  /// Spawn rate growth factor per wave for external systems to use.
  final double spawnGrowthPerWave;

  const SurvivorRunState({
    this.wave = 0,
    this.timeSec = 0,
    this.damagePerSec = 1,
    this.health = 100,
    this.dpsGrowthPerWave = 0,
    this.spawnGrowthPerWave = 0,
  }) : assert(health >= 0);

  SurvivorRunState copyWith({
    int? wave,
    double? timeSec,
    double? damagePerSec,
    double? health,
    double? dpsGrowthPerWave,
    double? spawnGrowthPerWave,
  }) =>
      SurvivorRunState(
        wave: wave ?? this.wave,
        timeSec: timeSec ?? this.timeSec,
        damagePerSec: damagePerSec ?? this.damagePerSec,
        health: health ?? this.health,
        dpsGrowthPerWave: dpsGrowthPerWave ?? this.dpsGrowthPerWave,
        spawnGrowthPerWave: spawnGrowthPerWave ?? this.spawnGrowthPerWave,
      );

  /// Advance the simulation by [dt] seconds.
  /// - Applies incoming damage: health' = max(0, health - dps*dt)
  /// - Increments time and waves every 30 seconds.
  SurvivorRunState tick(double dt) {
    final nextTime = timeSec + dt;
    final nextWave = (nextTime ~/ 30) > wave ? wave + 1 : wave;
    final effectiveDps = damagePerSec * (1 + wave * dpsGrowthPerWave);
    final dmg = (effectiveDps * dt).clamp(0, double.infinity).toDouble();
    final nextHealth = (health - dmg).clamp(0, double.infinity).toDouble();
    return copyWith(timeSec: nextTime, wave: nextWave, health: nextHealth);
  }

  bool get isDead => health <= 0;

  /// DPS after applying wave-based difficulty scaling.
  double get effectiveDps => damagePerSec * (1 + wave * dpsGrowthPerWave);

  /// Multiplier to scale spawn rates externally (e.g., emit more enemies per second).
  double get spawnRateMultiplier => 1 + wave * spawnGrowthPerWave;

  Map<String, Object?> toJson() => {
        'wave': wave,
        'timeSec': timeSec,
        'damagePerSec': damagePerSec,
        'health': health,
        'dpsGrowthPerWave': dpsGrowthPerWave,
        'spawnGrowthPerWave': spawnGrowthPerWave,
      };

  static SurvivorRunState fromJson(Map<String, Object?> json) =>
      SurvivorRunState(
        wave: (json['wave'] as num?)?.toInt() ?? 0,
        timeSec: (json['timeSec'] as num?)?.toDouble() ?? 0,
        damagePerSec: (json['damagePerSec'] as num?)?.toDouble() ?? 1,
        health: (json['health'] as num?)?.toDouble() ?? 100,
        dpsGrowthPerWave: (json['dpsGrowthPerWave'] as num?)?.toDouble() ?? 0,
        spawnGrowthPerWave:
            (json['spawnGrowthPerWave'] as num?)?.toDouble() ?? 0,
      );
}
