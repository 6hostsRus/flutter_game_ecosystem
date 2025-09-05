// change-class: infra
// Merges multiple lcov.info files under packages/*/coverage into a single coverage/lcov.info
// Basic concatenation ignoring duplicate TN headers.
import 'dart:io';

void main() async {
  final root = Directory('packages');
  final buffer = StringBuffer();
  if (!root.existsSync()) {
    stderr.writeln('No packages directory found.');
    exit(0);
  }
  for (final entity in root.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('coverage/lcov.info')) {
      final content = await entity.readAsString();
      for (final line in content.split('\n')) {
        if (line.startsWith('TN:'))
          continue; // drop test name lines to reduce noise
        buffer.writeln(line);
      }
    }
  }
  final outDir = Directory('coverage');
  if (!outDir.existsSync()) outDir.createSync();
  final outFile = File('coverage/lcov.info');
  outFile.writeAsStringSync(buffer.toString());
  stdout.writeln('Merged coverage written to coverage/lcov.info');
}
