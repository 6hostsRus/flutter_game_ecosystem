import 'dart:io';
import 'package:test/test.dart';

void main() {
  test('sample pack validates successfully via CLI', () async {
    // Resolve repo root two levels up from tools/schema_validator
    final repoRoot = Directory.current.parent.parent.path;
    final result = await Process.run(
      'dart',
      [
        'run',
        'tools/schema_validator/bin/validate_schemas.dart',
        '--schema-dir',
        'packages/game_core/assets/schemas',
        '--input-dir',
        'modules/content_packs/sample_pack',
      ],
      workingDirectory: repoRoot,
    );

    if (result.exitCode != 0) {
      stderr.writeln('STDOUT: ${result.stdout}');
      stderr.writeln('STDERR: ${result.stderr}');
    }
    expect(result.exitCode, 0);
    // Validator prints success to stderr per tool convention
    final combined = '${result.stdout}\n${result.stderr}'.toString();
    expect(combined.contains('All files validated successfully.'), isTrue);
  });
}
