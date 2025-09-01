library providers.flags.flag_provider;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:services/flags/flag_evaluator.dart';

final flagEvaluatorProvider = FutureProvider<FlagEvaluator>((ref) async {
  final jsonStr = await rootBundle.loadString('assets/flags.local.json');
  return FlagEvaluator.fromJson(jsonStr);
});
