// ignore_for_file: public_member_api_docs

import 'dart:convert';

/// Typed configuration for the Match board, mirroring examples/configurator/schemas/board.v1.json.
class BoardConfig {
  final int width;
  final int height;
  final String gravity;   // down|up|left|right
  final String refill;    // bag|random
  final int? rngSeed;

  /// Tile kinds and optional spawn weights (length == kinds)
  final int kinds;
  final List<double>? weights;

  /// Match patterns & combo tuning. We keep these structured as Maps to stay forward compatible.
  final Map<String, dynamic> patterns;
  final double comboBase;
  final double comboPerCascade;

  /// Optional obstacle/yield/analytics sections kept free-form for forward compatibility.
  final Map<String, dynamic> obstacles;
  final Map<String, dynamic> yields;
  final Map<String, String> analytics;

  /// Raw meta (must include schema: board.v1)
  final Map<String, dynamic> meta;

  const BoardConfig({
    required this.width,
    required this.height,
    required this.gravity,
    required this.refill,
    required this.kinds,
    required this.patterns,
    required this.comboBase,
    required this.comboPerCascade,
    required this.meta,
    this.rngSeed,
    this.weights,
    this.obstacles = const {},
    this.yields = const {},
    this.analytics = const {},
  });

  factory BoardConfig.defaults() => const BoardConfig(
        width: 8,
        height: 8,
        gravity: 'down',
        refill: 'bag',
        rngSeed: null,
        kinds: 5,
        weights: null,
        patterns: {
          'line3': {'enabled': true},
          'line4': {'bonus': 'line_clear', 'power': 1},
          'line5': {'bonus': 'color_bomb', 'power': 1},
          'tee': {'bonus': 'cross_clear', 'power': 1},
          'ell': {'bonus': 'corner_bomb', 'power': 1},
        },
        comboBase: 1.0,
        comboPerCascade: 0.25,
        meta: {'schema': 'board.v1'},
      );

  BoardConfig copyWith({
    int? width,
    int? height,
    String? gravity,
    String? refill,
    int? rngSeed,
    int? kinds,
    List<double>? weights,
    Map<String, dynamic>? patterns,
    double? comboBase,
    double? comboPerCascade,
    Map<String, dynamic>? obstacles,
    Map<String, dynamic>? yields,
    Map<String, String>? analytics,
    Map<String, dynamic>? meta,
  }) {
    return BoardConfig(
      width: width ?? this.width,
      height: height ?? this.height,
      gravity: gravity ?? this.gravity,
      refill: refill ?? this.refill,
      rngSeed: rngSeed ?? this.rngSeed,
      kinds: kinds ?? this.kinds,
      weights: weights ?? this.weights,
      patterns: patterns ?? this.patterns,
      comboBase: comboBase ?? this.comboBase,
      comboPerCascade: comboPerCascade ?? this.comboPerCascade,
      obstacles: obstacles ?? this.obstacles,
      yields: yields ?? this.yields,
      analytics: analytics ?? this.analytics,
      meta: meta ?? this.meta,
    );
  }

  factory BoardConfig.fromMap(Map m) {
    // minimal validation; the configurator does full JSON-Schema validation pre-load
    final matches = (m['matches'] as Map?) ?? const {};
    final combo = (matches['combo'] as Map?) ?? const {};
    final tiles = (m['tiles'] as Map?) ?? const {};
    final board = (m['board'] as Map?) ?? const {};
    return BoardConfig(
      width: (board['width'] ?? 8) as int,
      height: (board['height'] ?? 8) as int,
      gravity: (board['gravity'] ?? 'down') as String,
      refill: (board['refill'] ?? 'bag') as String,
      rngSeed: board['rng_seed'] is int ? board['rng_seed'] as int : null,
      kinds: (tiles['kinds'] ?? 5) as int,
      weights: tiles['weights'] == null
          ? null
          : (tiles['weights'] as List).map((e) => (e as num).toDouble()).toList(),
      patterns: ((matches['patterns'] as Map?) ?? const {}).map((k, v) => MapEntry('$k', v)),
      comboBase: (combo['base'] ?? 1.0 as num).toDouble(),
      comboPerCascade: (combo['per_cascade'] ?? 0.25 as num).toDouble(),
      obstacles: (m['obstacles'] as Map?) ?? const {},
      yields: (m['yields'] as Map?) ?? const {},
      analytics: ((m['analytics'] as Map?) ?? const {}).map((k, v) => MapEntry('$k', '$v')),
      meta: (m['meta'] as Map?) ?? const {'schema': 'board.v1'},
    );
  }

  Map<String, dynamic> toMap() => {
        'board': {
          'width': width,
          'height': height,
          'gravity': gravity,
          'refill': refill,
          'rng_seed': rngSeed,
        },
        'tiles': {
          'kinds': kinds,
          if (weights != null) 'weights': weights,
        },
        'matches': {
          'patterns': patterns,
          'combo': {'base': comboBase, 'per_cascade': comboPerCascade},
        },
        if (obstacles.isNotEmpty) 'obstacles': obstacles,
        if (yields.isNotEmpty) 'yields': yields,
        if (analytics.isNotEmpty) 'analytics': analytics,
        'meta': meta,
      };

  String toJson() => jsonEncode(toMap());
}
