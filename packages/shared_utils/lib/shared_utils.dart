import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:services/analytics/analytics_port.dart' as analytics;

/// Thin, centralized utilities used across the mono-repo.
///
/// Mark a Future as intentionally not awaited.
///
/// This helper centralizes fire-and-forget semantics. Unlike previous
/// implementations which silently swallowed errors, the current design
/// reports unhandled exceptions so they can be collected for metrics or
/// surfaced to a top-level error handler.
///
/// You can register an application-level handler via
/// `setUnhandledErrorHandler` which will receive the exception and optional
/// stack trace when an unawaited future fails. If no handler is registered
/// the error is forwarded to `Zone.current.handleUncaughtError`.
///
/// If you specifically want to suppress reporting for a particular call
/// site you can still opt-out by passing `handleErrors: true` which attaches
/// a no-op handler.
///
/// Example:
///
///   unawaited(someAsyncWork()); // reports failures to registered handler
///
///   // Suppress reporting for this call-site:
///   unawaited(someAsyncWork(), handleErrors: true);

typedef UnhandledErrorHandler = void Function(Object error, StackTrace? stack);

UnhandledErrorHandler? _unhandledErrorHandler;

/// Register a handler to receive unhandled errors from `unawaited` calls.
///
/// The handler should be fast and non-throwing; it's invoked synchronously
/// from the attached future error handler. It's safe to call this at
/// application bootstrap time.
void setUnhandledErrorHandler(UnhandledErrorHandler? handler) {
  _unhandledErrorHandler = handler;
}

void unawaited<T>(Future<T> future, {bool handleErrors = false}) {
  if (handleErrors) {
    // Attach a no-op error handler so errors are not reported.
    future.then((_) {}, onError: (_) {});
    return;
  }

  // Attach an error handler that forwards the exception to a registered
  // handler, or to the current Zone's uncaught error handler as a fallback.
  future.then((_) {}, onError: (Object error, StackTrace? stack) {
    try {
      if (_unhandledErrorHandler != null) {
        _unhandledErrorHandler!(error, stack);
      } else {
        // No handler registered: prefer reporting to the global analytics
        // sink if one is registered (set by provider bundles). This keeps
        // telemetry consistent in apps that wire analytics, but still
        // preserves the NDJSON fallback for CI/CLI tooling.
        try {
          final sink = analytics.getGlobalAnalyticsPort();
          if (sink != null) {
            sink.send(analytics.AnalyticsEvent('unawaited_error', {
              'ts': DateTime.now().toIso8601String(),
              'error': error.toString(),
              'stack': stack?.toString(),
              'source': 'shared_utils.unawaited'
            }));
          } else {
            final out = File('../../build/metrics/unhandled_exceptions.ndjson');
            out.parent.createSync(recursive: true);
            final entry = {
              'ts': DateTime.now().toIso8601String(),
              'error': error.toString(),
              'stack': stack?.toString(),
              'source': 'shared_utils.unawaited'
            };
            out.writeAsStringSync(jsonEncode(entry) + '\n',
                mode: FileMode.append);
          }
        } catch (_) {
          Zone.current.handleUncaughtError(error, stack ?? StackTrace.current);
        }
      }
    } catch (_) {
      // Protect callers from exceptions thrown by the metrics handler.
      // As a last resort, forward to the Zone so the error is not lost.
      try {
        Zone.current.handleUncaughtError(error, stack ?? StackTrace.current);
      } catch (_) {}
    }
  });
}
