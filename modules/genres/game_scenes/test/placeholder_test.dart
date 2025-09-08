import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:game_scenes/scene_diagnostics.dart';

void main() {
  test('placeholder game_scenes passes', () {
    expect(1 + 1, 2);
  });

  test('SceneDiagnostics emits: info scene_start with rng sample', () {
    final log = MemoryLogger();
    final rng = DeterministicRng(7);
    final diag = SceneDiagnostics(logger: log, rng: rng);
    final v = diag.emitStartupSample();
    expect(v, inInclusiveRange(0, 999));
    expect(log.entries.single.level, LogLevel.info);
    expect(log.entries.single.message, 'scene_start');
    expect(log.entries.single.fields?['sample'], v);
  });
}
