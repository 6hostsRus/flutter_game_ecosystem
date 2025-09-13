#!/usr/bin/env markdown

# Wiring Validation in the Configurator Runtime
Updated: 2025-09-11

Use `buildAndValidate(...)` from `examples/configurator/lib/config_runtime.dart` when:
- the user selects a new pack in the drawer,
- a watched config file changes,
- or a device/dev override is edited.

If `ValidationReport.ok == true`, use `report.merged`:
- Feed to providers (e.g., `mergeChainProvider`, `telemetryProvider`).
- Convert to typed config for the selected engine (e.g., `BoardConfig.fromMap(report.merged)` for match).

If `ok == false`, surface `report.errors` in the Validation tab and **keep the last good state**.
