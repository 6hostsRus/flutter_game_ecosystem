import 'package:game_core/game_core.dart';

class SceneDiagnostics {
  final Logger logger;
  final Rng rng;
  SceneDiagnostics({required this.logger, required this.rng});

  int emitStartupSample() {
    final sample = rng.nextInt(1000);
    logger.info('scene_start', {'sample': sample});
    return sample;
  }
}
