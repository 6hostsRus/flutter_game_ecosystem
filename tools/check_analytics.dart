// Verifies minimum analytics instrumentation presence.
import 'dart:io';

void main(List<String> args) {
  final testDir = Directory('packages/services/test/analytics');
  if (!testDir.existsSync()) {
    stderr.writeln('No analytics tests directory found');
    exit(1);
  }
  final tests =
      testDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('_analytics_test.dart'))
          .toList();
  if (tests.length < 2) {
    stderr.writeln(
      'Expected at least 2 analytics tests, found ${tests.length}',
    );
    exit(2);
  }
  stdout.writeln('Analytics test count OK (${tests.length}).');
}
