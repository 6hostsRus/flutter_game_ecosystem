import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';

void main() {
  test('MemoryLogger records entries with levels and fields', () {
    final log = MemoryLogger();
    log.info('boot', {'v': 1});
    log.warn('low battery');
    log.error('crash', {'code': 500});

    expect(log.entries.length, 3);
    expect(log.entries.first.level, LogLevel.info);
    expect(log.entries.first.message, 'boot');
    expect(log.entries.first.fields?['v'], 1);
    expect(log.entries.last.level, LogLevel.error);
    expect(log.entries.last.fields?['code'], 500);
  });
}
