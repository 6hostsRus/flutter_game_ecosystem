import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class PlatformerGame extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF0F0F12);

  @override
  Future<void> onLoad() async {
    // TODO: load a player sprite, level map, and basic physics.
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: movement/physics update
  }
}

Widget platformerWidget() => GameWidget(game: PlatformerGame());
