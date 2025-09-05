# AI Policy

Guiding principles & boundaries.

## Principles

-    Incremental, reversible changes.
-    Keep PRs focused.
-    Annotate assumptions when ambiguity exists.
-    No deletion without deprecation notice.

## Prohibited

-    Adding runtime deps without manifest update.
-    Silent large refactors.
-    Committing secrets.

## Stub Parity Policy

Every stub must include:

1. Upstream reference version comment.
2. TODO(parity:<YYYY-MM-DD>) entry.
3. Covered by `tools/check_stub_parity.dart`.

## Documentation Policy

-    Consolidated architecture lives in `docs/STACK.md`.
-    Deprecated docs retain banner until next minor release.

## Security

-    Secrets via GitHub Actions only.
-    Fail build on parity or secret scan failure.
