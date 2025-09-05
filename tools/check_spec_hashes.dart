// change-class: infra
// Verifies documented spec hash for route registry matches current file hash.
// Emits a GitHub Actions warning (::warning::) on mismatch but exits 0 (non-fatal).
import 'dart:io';
import 'package:crypto/crypto.dart';

void main(List<String> args) {
  const path = 'tools/route_spec/route_registry.json';
  const doc = 'docs/SPEC_HASHES.md';
  final specFile = File(path);
  if (!specFile.existsSync()) {
    stderr.writeln('Spec file missing: $path');
    exit(0); // nothing to compare
  }
  final bytes = specFile.readAsBytesSync();
  final currentHash = sha1.convert(bytes).toString();
  final docFile = File(doc);
  if (!docFile.existsSync()) {
    stdout.writeln('SPEC_HASHES doc missing; skipping hash warning.');
    return;
  }
  final docText = docFile.readAsStringSync();
  final regex = RegExp(
    r'`tools/route_spec/route_registry.json` \| `([a-f0-9]{40})`',
  );
  final m = regex.firstMatch(docText);
  if (m == null) {
    stdout.writeln('Route spec hash not documented yet.');
    return;
  }
  final documented = m.group(1)!;
  final strict =
      args.contains('--strict') ||
      Platform.environment['SPEC_HASH_STRICT'] == '1';
  final mismatch = documented != currentHash;
  if (mismatch) {
    final msg =
        'Route spec hash mismatch (docs $documented vs current $currentHash). Regenerate with spec_hashes.dart';
    if (strict) {
      stderr.writeln(msg);
      exit(2);
    } else {
      stdout.writeln('::warning:: $msg');
    }
  } else {
    stdout.writeln('Route spec hash OK ($currentHash)');
  }
}
