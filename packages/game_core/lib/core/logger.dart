enum LogLevel { debug, info, warn, error }

class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final Map<String, Object?>? fields;

  LogEntry(this.timestamp, this.level, this.message, [this.fields]);
}

abstract class Logger {
  void log(LogLevel level, String message, [Map<String, Object?>? fields]);

  void debug(String message, [Map<String, Object?>? fields]) =>
      log(LogLevel.debug, message, fields);
  void info(String message, [Map<String, Object?>? fields]) =>
      log(LogLevel.info, message, fields);
  void warn(String message, [Map<String, Object?>? fields]) =>
      log(LogLevel.warn, message, fields);
  void error(String message, [Map<String, Object?>? fields]) =>
      log(LogLevel.error, message, fields);
}

class ConsoleLogger implements Logger {
  const ConsoleLogger();

  @override
  void log(LogLevel level, String message, [Map<String, Object?>? fields]) {
    final ts = DateTime.now().toIso8601String();
    final ctx = fields == null || fields.isEmpty ? '' : ' ${fields.toString()}';
    // ignore: avoid_print
    print('[$ts] ${level.name.toUpperCase()} $message$ctx');
  }

  @override
  void debug(String message, [Map<String, Object?>? fields]) =>
      log(LogLevel.debug, message, fields);

  @override
  void info(String message, [Map<String, Object?>? fields]) =>
      log(LogLevel.info, message, fields);

  @override
  void warn(String message, [Map<String, Object?>? fields]) =>
      log(LogLevel.warn, message, fields);

  @override
  void error(String message, [Map<String, Object?>? fields]) =>
      log(LogLevel.error, message, fields);
}

class MemoryLogger implements Logger {
  final List<LogEntry> entries = <LogEntry>[];

  @override
  void log(LogLevel level, String message, [Map<String, Object?>? fields]) {
    entries.add(LogEntry(DateTime.now(), level, message, fields));
  }

  @override
  void debug(String message, [Map<String, Object?>? fields]) =>
      log(LogLevel.debug, message, fields);

  @override
  void info(String message, [Map<String, Object?>? fields]) =>
      log(LogLevel.info, message, fields);

  @override
  void warn(String message, [Map<String, Object?>? fields]) =>
      log(LogLevel.warn, message, fields);

  @override
  void error(String message, [Map<String, Object?>? fields]) =>
      log(LogLevel.error, message, fields);
}
