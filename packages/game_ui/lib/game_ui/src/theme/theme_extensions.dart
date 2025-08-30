import 'package:flutter/material.dart';
import 'tokens.dart';

extension GameThemeX on BuildContext {
  GameTokens get tokens => Theme.of(this).extension<GameTokens>() ?? const GameTokens();
}
