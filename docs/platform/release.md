# Platform Release Guide

Updated: 2025-09-07

This guide documents platform release inputs/variables and example runs.

Workflow

-    File: `.github/workflows/platform-release.yml`
-    Trigger: `workflow_dispatch`

Inputs

-    `enable` (true/false): Guard to run release steps. Default: false.
-    `release_platform`: android | ios | web (default: android)
-    `release_track`: internal | alpha | beta | production (default: internal)
-    `upload_store`: true | false (default: false). When true, attempt Android upload to Google Play if secrets are configured. iOS upload is currently a placeholder.

## Secrets

Configure these repo secrets under Settings → Secrets and variables → Actions:

Android / Google Play

-    `PLAY_JSON_KEY` — Paste the FULL service account JSON (raw JSON text) with Play Console Publisher access.

Apple / App Store Connect

-    `APPSTORE_KEY_ID` — App Store Connect API Key ID
-    `APPSTORE_ISSUER_ID` — App Store Connect Issuer ID
-    `APPSTORE_P8` — Base64-encoded contents of the .p8 private key (the workflow decodes this into a file)

Example runs

-    Build-only (android, internal):
     -    enable=true, release_platform=android, release_track=internal
-    iOS build-only:
     -    enable=true, release_platform=ios, release_track=internal
-    Web build:
     -    enable=true, release_platform=web, release_track=internal

Notes

-    Upload steps are skipped unless the corresponding secrets are present.
-    Android: Set `upload_store=true` to attempt Play upload using `r0adkll/upload-google-play`. Missing secrets will cause the step to fail; keep `upload_store=false` for build-only runs.
-    iOS: Set `upload_store=true` to upload to TestFlight via Fastlane (pilot) on a macOS runner using the `APPSTORE_*` secrets. If no IPA is found or secrets are missing, the step is skipped; artifacts are still uploaded for manual submission.
-    Submissions are not enabled by default; extend as needed per store policy.
