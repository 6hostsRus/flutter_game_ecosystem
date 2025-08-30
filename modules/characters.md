# Characters Module (V1)

## Purpose
Unified system for player/NPC entities: stats, movement, animations, collisions.

## Key Types
```dart
abstract class CharacterController {
  void update(double dt, Character c);
}

class Character {
  final String id;
  Vector2 position;
  Vector2 velocity;
  double facing; // radians
  CharacterStats stats;
  AnimationSet animations;
  PhysicsHandle? physics; // Forge2D wrapper
}
```

## Features
- **Stats & States**: HP, speed, jump, energy; state machine (Idle/Move/Attack/Hit/Dead).
- **Physics**: optional body/fixture creation via Forge2D adapter.
- **Animations**: sprite/atlas pipelines + simple `AnimationSet` map by state/action.
- **AI hooks**: pluggable `CharacterController` for bots.

## Config
- JSON for character archetypes (walk speed, collider size, sprite paths).

## Deliverables (v1)
- Data classes + state machine
- Forge2D body factory
- Basic atlas animation helper
- Sample: `RunnerHero`, `BasicEnemy`
