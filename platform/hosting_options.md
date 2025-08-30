# Hosting & Management Options (V2)

## Firebase-first (fastest cash path)
- Analytics + Remote Config, AdMob, Firestore optional.
- Pros: fast, minimal ops. Cons: Google lock-in.

## AWS Amplify (fits stack)
- Cognito, AppSync, S3, Pinpoint.
- Pros: integrates AWS infra. Cons: heavier.

## Hybrid (recommended)
- Ship V1 with Firebase (ads/analytics).
- Keep DB pluggable; add Amplify later.
