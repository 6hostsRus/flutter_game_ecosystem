
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class SurvivorGame extends FlameGame {
  double time = 0;
  int wave = 0;

  @override
  Color backgroundColor() => const Color(0xFF0E141B);

  @override
  void update(double dt) {
    time += dt;
    final nextWave = (time ~/ 30).toInt();
    if (nextWave > wave) {
      wave = nextWave;
      // TODO: spawn tougher enemies
    }
  }
}

Widget survivorWidget() => GameWidget(game: SurvivorGame());
