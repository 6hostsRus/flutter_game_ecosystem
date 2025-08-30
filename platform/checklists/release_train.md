# Multi-Platform Release Train (iOS + Android)

> Use this unified checklist for synchronized store releases. Each item is written to map cleanly to issue/task creation.

## 0) Versioning & Branching
- [ ] Create `release/x.y.z` branch
- [ ] Bump app version codes (iOS CFBundleShortVersionString/Build, Android versionName/versionCode)
- [ ] Update CHANGELOG.md
- [ ] Tag `vX.Y.Z` after store approvals

## 1) Compliance & Privacy
- [ ] Update Privacy Policy URL (hosted & reachable)
- [ ] Review data collection map (SDKs, analytics, ads)
- [ ] iOS: App Privacy labels updated
- [ ] iOS: ATT prompt logic validated (if IDFA)
- [ ] Android: Data Safety form updated (AdMob + other SDKs)

## 2) Monetization & Remote Flags
- [ ] Validate AdMob unit IDs (test vs prod)
- [ ] Rewarded/interstitial placement flags in Remote Config
- [ ] Frequency caps verified (cooldowns respected)
- [ ] IAP products (if any) present and in correct state (Cleared for sale/Active)

## 3) Assets Matrix
- [ ] Icon sets generated (iOS 1024x1024, Android 512x512)
- [ ] Feature graphic (Android 1024x500)
- [ ] Screenshots (phones & tablets: iOS 6.7/5.5/iPad; Android phone/7"/10")
- [ ] Video preview (optional) prepared
- [ ] Store descriptions (short/full) reviewed with keywords

## 4) Build & Validate
- [ ] iOS: Archive in Xcode → upload to App Store Connect
- [ ] iOS: TestFlight build distributed to testers
- [ ] Android: Generate signed AAB (release keystore)
- [ ] Android: Upload to Play Console (internal test or closed track)
- [ ] Crash-free smoke tests on 3–5 devices per platform

## 5) Store Config
- [ ] iOS: Content rating questionnaire completed
- [ ] iOS: App Review notes + demo credentials added (if needed)
- [ ] Android: Content rating questionnaire completed
- [ ] Android: Target API level compliant & Play App Signing enabled
- [ ] Categories, age ratings, pricing set on both stores

## 6) Review & Rollout
- [ ] iOS: Submit for review
- [ ] Android: Promote from internal/closed to production (staged rollout %)
- [ ] Monitor review feedback; respond to required changes
- [ ] Post-approval: publish release notes

## 7) Post-Launch
- [ ] Enable production Remote Config flags (ads, events)
- [ ] Verify analytics dashboards (events, retention proxies, ARPDAU)
- [ ] In-app review prompts gated by engagement rules
- [ ] Cross-promo slot updated (promote next title)
