abstract class EngineRuntime<Cfg> {
  Cfg fromMap(Map<String, dynamic> json);
  List<String> validate(Cfg cfg);
  EngineSession start(Cfg cfg, {required int seed});
  Stream<EngineEvent> get events;
}

abstract class EngineSession {
  void step([int ticks = 1]);
  void dispose();
}

class EngineEvent {
  final String type;
  final Map<String, dynamic> data;
  EngineEvent(this.type, this.data);
}
