import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
class GameTokens extends ThemeExtension<GameTokens> {
  final double hudPadding;
  final double cardRadius;
  final double elevation;

  const GameTokens({
    this.hudPadding = 12,
    this.cardRadius = 16,
    this.elevation = 1,
  });

  @override
  GameTokens copyWith(
          {double? hudPadding, double? cardRadius, double? elevation}) =>
      GameTokens(
        hudPadding: hudPadding ?? this.hudPadding,
        cardRadius: cardRadius ?? this.cardRadius,
        elevation: elevation ?? this.elevation,
      );

  @override
  ThemeExtension<GameTokens> lerp(ThemeExtension<GameTokens>? other, double t) {
    if (other is! GameTokens) return this;
    return GameTokens(
      hudPadding: lerpDouble(hudPadding, other.hudPadding, t)!,
      cardRadius: lerpDouble(cardRadius, other.cardRadius, t)!,
      elevation: lerpDouble(elevation, other.elevation, t)!,
    );
  }
}
