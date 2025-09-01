library providers.flags.flag_provider;

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:services/flags/flag_evaluator.dart';
import 'package:services/flags/remote_overrides.dart';

/// Optional remote overrides source provider. Override in your app boot code.
final flagOverridesSourceProvider = Provider<FlagOverridesSource?>((ref) => null);

/// Loads local flags, applies optional remote overrides, and exposes a FlagEvaluator.
final flagEvaluatorProvider = FutureProvider<FlagEvaluator>((ref) async {
  // 1) Local asset
  final jsonStr = await rootBundle.loadString('assets/flags.local.json');
  final local = json.decode(jsonStr) as Map<String, dynamic>;

  // 2) Remote overrides (optional)
  final src = ref.read(flagOverridesSourceProvider);
  Map<String, dynamic> merged = local;
  if (src != null) {
    final remote = await src.fetch();
    merged = FlagEvaluator.merge(local, remote);
  }
  return FlagEvaluator.fromMaps(merged);
});
