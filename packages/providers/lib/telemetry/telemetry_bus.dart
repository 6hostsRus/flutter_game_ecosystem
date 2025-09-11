// ignore_for_file: public_member_api_docs

import 'dart:async';

class TelemetryBus {
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _controller.stream;
  void emit(Map<String, dynamic> event) => _controller.add(event);
  void dispose() => _controller.close();
}
