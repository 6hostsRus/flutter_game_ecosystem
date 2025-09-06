# Release Gates — Final Mapping

Generated: 2025-09-06T14:31:36.267006Z

Summary: configured 11/11 (mandatory: 8/8), planned 0, missing 0

| Gate | Script | Workflow | Mandatory | Status | Notes |
|------|--------|----------|-----------|--------|-------|
| Stub Parity | `tools/check_stub_parity.dart` | .github/workflows/ci.yml | Yes | ok | parity OK per docs/METRICS.md; workflow: .github/workflows/ci.yml |
| Manifest Completeness | `tools/check_manifest.dart` | .github/workflows/ci.yml | Yes | configured | workflow: .github/workflows/ci.yml |
| Coverage Threshold | `tools/coverage_policy.yaml` | .github/workflows/ci.yml | Yes | configured | coverage 56.9%; workflow: .github/workflows/ci.yml |
| Route Spec Hash (strict) | `tools/check_spec_hashes.dart` | .github/workflows/ci.yml | Yes | configured | workflow: .github/workflows/ci.yml |
| Analytics Tests Minimum | `tools/run_quality_gates.dart` | .github/workflows/ci.yml | Yes | configured | workflow: .github/workflows/ci.yml |
| Package Status Audit | `tools/package_status_audit.dart` | .github/workflows/ci.yml | No | configured | workflow: .github/workflows/ci.yml |
| Content Pack Schemas | `tools/schema_validator/bin/validate_schemas.dart` | .github/workflows/ci.yml | Yes | configured | workflow: .github/workflows/ci.yml |
| Policy Guard (Gitleaks) | `.github/workflows/gitleaks.yml` | .github/workflows/gitleaks.yml | Yes | configured | workflow: .github/workflows/gitleaks.yml |
| Checklist Visibility | `tools/generate_task_checklist.dart` | .github/workflows/checklist-visibility.yml | No | configured | workflow: .github/workflows/checklist-visibility.yml |
| Stack Consolidation | `tools/consolidate_stack_docs.dart` | .github/workflows/consolidate-stack.yml | No | configured | workflow: .github/workflows/consolidate-stack.yml |
| Golden Guard (planned) | `.github/workflows/golden-guard.yml` | .github/workflows/golden-guard.yml | Yes | configured | workflow: .github/workflows/golden-guard.yml |
