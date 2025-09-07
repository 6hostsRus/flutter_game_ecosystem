import 'dart:io';
import 'package:test/test.dart';

void main() {
  test('default schema dir exists in-core', () async {
    // Prefer repo-root-relative path used by CI; fallback to package-relative when running tests from this folder.
    final rootRelative = Directory('game_core/assets/schemas');
    final packageRelative = Directory('../../game_core/assets/schemas');
    final dir = await rootRelative.exists() ? rootRelative : packageRelative;
    expect(await dir.exists(), isTrue,
        reason:
            'Expected game_core/assets/schemas to exist relative to repo root or package');

    final files = await dir.list().toList();
    expect(
      files
          .whereType<File>()
          .map((f) => f.path)
          .any((p) => p.endsWith('manifest.schema.json')),
      isTrue,
      reason: 'manifest.schema.json should be present',
    );
  });
}
