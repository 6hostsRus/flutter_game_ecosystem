import 'package:isar/isar.dart';

part 'idle_dao.g.dart';

@collection
class IdleStateEntity {
  Id id = 0;

  DateTime? lastSeen = DateTime.now();
  double totalRatePerSec = 0.0;

  IdleStateEntity({DateTime? lastSeen, this.totalRatePerSec = 0})
      : lastSeen = lastSeen ?? DateTime.now();
}

@embedded
class GeneratorEntity {
  String id;
  int level;
  double baseRatePerSec;
  double multiplier;
  bool unlocked;
  GeneratorEntity(
      {this.id = '',
      this.level = 0,
      this.baseRatePerSec = 0,
      this.multiplier = 1,
      this.unlocked = false});
}
