library services.flags.flag_evaluator;

import 'dart:convert';
import 'dart:math';

class FlagEvaluator {
  final Map<String, dynamic> _flags;
  final Random _rand;
  FlagEvaluator(this._flags, {Random? rand}) : _rand = rand ?? Random();

  bool isEnabled(String flagName, {Map<String, dynamic>? context}) {
    final flag = _flags[flagName];
    if (flag == null) return false;
    if (flag is bool) return flag;

    if (flag is Map<String, dynamic>) {
      if (flag.containsKey('rollout')) {
        final prob = (flag['rollout'] as num).toDouble();
        return _rand.nextDouble() < prob;
      }
      if (context != null && flag.containsKey('conditions')) {
        final conditions = flag['conditions'] as Map<String, dynamic>;
        for (final entry in conditions.entries) {
          final key = entry.key;
          final allowed = (entry.value as List).map((e) => e.toString()).toList();
          if (context[key] == null || !allowed.contains(context[key].toString())) {
            return false;
          }
        }
        return true;
      }
    }
    return false;
  }

  static FlagEvaluator fromJson(String jsonStr) {
    return FlagEvaluator(json.decode(jsonStr) as Map<String, dynamic>);
  }
}
