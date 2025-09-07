# Automation: Quick Ops and Secrets (Canonical)

Updated: 2025-09-07

This is the canonical source for quick-ops commands and required secrets. See also `.github/workflows/` and `docs/WORKFLOWS.md`.

## Quick Ops Cheatsheet

Daily PR Flow

-    Open PR → CI runs (analyze, format, test, coverage), auto-labeling, added to project.

Release Flow

1. `/release-candidate 0.1.0` → creates milestone, draft release, and tasks.
2. `/screenshots ios` and `/screenshots android` → build and upload screenshot artifacts.
3. `/submit-ios` and `/promote android internal` → TestFlight upload / Play internal track.
4. Review → `/promote android production 20%` → `/promote android production 100%`.
5. `/store sync ios` and `/store sync android` → push listing metadata + images.

Hotfix Flow

-    `/hotfix start 1.2.3` → creates branch & PR; merge fixes; `/hotfix release 1.2.3`.

Extras

-    `/epic "Runner MVP" children: #12 #34` • `/project to Game Ecosystem Board/In progress`.

## Secrets to Configure

Google Play / Android

-    `PLAY_JSON_KEY` — service account JSON for Play Console
-    `ANDROID_KEYSTORE`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`

Apple / iOS

-    `APPSTORE_ISSUER_ID`, `APPSTORE_KEY_ID`, `APPSTORE_P8` (base64)
-    or Fastlane Match secrets (`MATCH_PASSWORD`, repo creds)

GitHub

-    `GH_TOKEN` — repo + project write permissions

Firebase (optional)

-    `FIREBASE_SA_JSON` — service account JSON for Remote Config, etc.

Notifications (optional)

-    `SLACK_WEBHOOK_URL` • `DISCORD_WEBHOOK_URL`

### Platform Release workflow secrets (mirror)

These are the exact secret names consumed by `.github/workflows/platform-release.yml` and documented in `docs/platform/release.md`:

-    Android: `PLAY_JSON_KEY`
-    iOS: `APPSTORE_KEY_ID`, `APPSTORE_ISSUER_ID`, `APPSTORE_P8` (base64 of .p8)

Notes:

-    iOS uploads run on macOS and use Fastlane (pilot). The workflow writes an `asc_api_key.json` from the above secrets at runtime.

## Platform Release Notes

-    See `docs/platform/release.md` for the release workflow inputs and examples.
-    The platform-release workflow supports optional Android upload (internal/alpha/beta/production) when configured.
-    iOS upload is currently a placeholder; use a macOS runner and Fastlane/ASC setup.
