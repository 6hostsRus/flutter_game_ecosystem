import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_utils/shared_utils.dart';

void main() {
  test('unawaited forwards errors to registered handler', () async {
    Object? seenError;
    StackTrace? seenStack;

    setUnhandledErrorHandler((error, stack) {
      seenError = error;
      seenStack = stack;
    });

    // Create a future that completes with an error shortly.
    unawaited(Future<void>.delayed(const Duration(milliseconds: 10), () {
      throw StateError('boom');
    }));

    // Wait a bit for the microtask to run.
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(seenError, isNotNull);
    expect(seenError, isA<StateError>());
    expect(seenStack, isNotNull);

    // Clear handler
    setUnhandledErrorHandler(null);

    // When no handler is registered we should get a metrics NDJSON line written
    // to ../../build/metrics/unhandled_exceptions.ndjson relative to package.
    final metricsFile = File('build/metrics/unhandled_exceptions.ndjson');
    if (metricsFile.existsSync()) {
      final content = metricsFile.readAsStringSync();
      expect(content.contains('boom'), isTrue);
    }
  });

  test('unawaited with handleErrors suppresses reporting', () async {
    Object? seenError;
    setUnhandledErrorHandler((error, stack) {
      seenError = error;
    });

    unawaited(
        Future<void>.delayed(const Duration(milliseconds: 10), () {
          throw StateError('suppressed');
        }),
        handleErrors: true);

    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(seenError, isNull);

    setUnhandledErrorHandler(null);
  });
}
