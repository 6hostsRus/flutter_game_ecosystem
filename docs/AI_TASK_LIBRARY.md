# AI Task Library

Reusable task blueprints.

## CreateOrUpdateManifest

1. Read existing `packages/manifest.yaml`.
2. Merge new packages; preserve unknown keys.
3. Sort alphabetically; update last_updated.
4. Validate paths exist.

## ConsolidateStackDocs

1. Build `docs/STACK.md` from scattered sources.
2. Insert deprecation banners in superseded docs.

## HardenMonetizationAdapter

1. Add factory (if missing).
2. Add/Update adapter tests (status mapping).
3. Introduce feature flag for real plugin.

## AddStubParityCheck

1. Create/update `tools/check_stub_parity.dart`.
2. Ensure parity TODO tags exist.

## ScaffoldMetrics

1. Ensure `docs/METRICS.md` markers present.
2. (Later) Update from CI.

## ModularizeAIInstructions

1. Generate AI\_\* docs.
2. Replace root instructions with index linking.

## UpdateStub

1. Modify stub file.
2. Adjust parity date.
3. Run parity script.

## AddTest

1. Create test file mirroring lib path.
2. Import necessary fakes.
3. Assert key behaviors & edge cases.
