import 'package:flutter_test/flutter_test.dart';
import 'package:services/flags/flag_evaluator.dart';

void main() {
  test('simple bool flag', () {
    final f = FlagEvaluator({"foo": true});
    expect(f.isEnabled("foo"), true);
    expect(f.isEnabled("bar"), false);
  });

  test('rollout flag ~50%', () {
    final f = FlagEvaluator({"exp": {"rollout": 0.5}});
    var enabledCount = 0;
    for (int i = 0; i < 1000; i++) {
      if (f.isEnabled("exp")) enabledCount++;
    }
    expect(enabledCount, greaterThan(300));
    expect(enabledCount, lessThan(700));
  });

  test('contextual flag', () {
    final f = FlagEvaluator({
      "ios_only_feature": {
        "conditions": {"platform": ["ios"]}
      }
    });
    expect(f.isEnabled("ios_only_feature", context: {"platform": "ios"}), true);
    expect(f.isEnabled("ios_only_feature", context: {"platform": "android"}), false);
  });
}
