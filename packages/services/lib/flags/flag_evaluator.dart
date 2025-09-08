library services.flags.flag_evaluator;

import 'dart:convert';
import 'dart:math';

/// Evaluates feature flags locally based on JSON config.
class FlagEvaluator {
  final Map<String, dynamic> _flags;
  final Random _rand;

  FlagEvaluator(this._flags, {Random? rand}) : _rand = rand ?? Random();

  /// Returns whether a flag is enabled for this context.
  bool isEnabled(String flagName, {Map<String, dynamic>? context}) {
    final flag = _flags[flagName];
    if (flag == null) return false;

    // Simple boolean case
    if (flag is bool) return flag;

    // Object config case
    if (flag is Map<String, dynamic>) {
      // Probabilistic rollout
      if (flag.containsKey('rollout')) {
        final prob = (flag['rollout'] as num).toDouble();
        return _rand.nextDouble() < prob;
      }

      // Targeting by context fields
      if (context != null && flag.containsKey('conditions')) {
        final conditions = flag['conditions'] as Map<String, dynamic>;
        for (final entry in conditions.entries) {
          final key = entry.key;
          final allowed =
              (entry.value as List).map((e) => e.toString()).toList();
          if (context[key] == null ||
              !allowed.contains(context[key].toString())) {
            return false;
          }
        }
        return true;
      }
    }

    return false;
  }

  /// Merge two flag maps (remote overrides take precedence).
  static Map<String, dynamic> merge(
      Map<String, dynamic> base, Map<String, dynamic> override) {
    final out = Map<String, dynamic>.from(base);
    override.forEach((k, v) => out[k] = v);
    return out;
  }

  /// Load evaluator from a JSON string.
  static FlagEvaluator fromJson(String jsonStr) {
    return FlagEvaluator(json.decode(jsonStr) as Map<String, dynamic>);
  }

  /// Build from maps.
  static FlagEvaluator fromMaps(Map<String, dynamic> map) => FlagEvaluator(map);
}
