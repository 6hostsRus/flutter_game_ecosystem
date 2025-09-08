# shared_utils

Small utilities shared across the mono-repo.

## unawaited

Purpose
: Provide a single, explicit way to mark a Future as intentionally not awaited
(fire-and-forget) across the repository.

Usage

```dart
import 'package:shared_utils/shared_utils.dart';

// Mark a future as intentionally not awaited.
unawaited(someAsyncOperation());

// Optionally attach a no-op error handler to prevent unhandled exception
// reports for that call site:
unawaited(someAsyncOperation(), handleErrors: true);
```

Implementation notes
: This package intentionally provides a tiny local shim for `unawaited`
instead of depending on an external package. That keeps the runtime
dependency surface small and preserves a single source-of-truth for
the helper. If we later need more advanced behavior (metrics, logging,
telemetry), expand the implementation here and all call sites will inherit
the change.
