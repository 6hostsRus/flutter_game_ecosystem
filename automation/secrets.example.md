# Secrets to Configure

## Google Play / Android
- `PLAY_JSON_KEY` — JSON service account for Play Console.
- `ANDROID_KEYSTORE` — base64-encoded keystore file.
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

## Apple / iOS
- `APPSTORE_ISSUER_ID`
- `APPSTORE_KEY_ID`
- `APPSTORE_P8` — base64-encoded .p8 key content (App Store Connect API key)
- or Fastlane Match secrets (`MATCH_PASSWORD`, repo creds)

## GitHub
- `GH_TOKEN` — classic token or fine-grained with **repo** + **project** write.

## Firebase (optional)
- `FIREBASE_SA_JSON` — service account JSON for Remote Config API.

## Project (Beta)
- `PROJECT_URL` — URL of your Project v2 board.
