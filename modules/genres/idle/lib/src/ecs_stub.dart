/// Minimal ECS stub for idle genre examples.
/// Not a full engine; enough to demonstrate component conversion and a system.

import 'idle_models.dart';

class Entity {
  static int _nextId = 1;
  final int id;
  final Map<Type, Object> _components = <Type, Object>{};
  Entity._(this.id);

  T? get<T extends Object>() => _components[T] as T?;
  void set<T extends Object>(T component) => _components[T] = component;
  bool hasAll(Iterable<Type> types) => types.every(_components.containsKey);
}

class World {
  final List<Entity> entities = <Entity>[];
  Entity createEntity() {
    final e = Entity._(Entity._nextId++);
    entities.add(e);
    return e;
  }

  Iterable<Entity> query(List<Type> componentTypes) =>
      entities.where((e) => e.hasAll(componentTypes));
}

/// System that applies generator income into the idle state's soft currency.
class IdleIncomeSystem {
  static void tick(World world, double dtSeconds) {
    final stateEntity =
        world.query([IdleStateComponentData]).cast<Entity>().firstOrNull;
    if (stateEntity == null) return;
    final state = stateEntity.get<IdleStateComponentData>()!;

    double delta = 0.0;
    for (final e in world.query([GeneratorComponentData])) {
      final g = e.get<GeneratorComponentData>()!;
      delta += g.ratePerSec * g.multiplier * dtSeconds;
    }
    stateEntity.set<IdleStateComponentData>(IdleStateComponentData(
      epochMillis: state.epochMillis,
      softCurrency: state.softCurrency + delta,
      prestigePoints: state.prestigePoints,
    ));
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
