# Unified Release Checklist (iOS + Android)

## Assets (both)
- [ ] App icon(s)
- [ ] Screenshots (phone, tablet)
- [ ] Feature/marketing graphics
- [ ] Privacy policy URL
- [ ] Support URL
- [ ] App description (short + full)

## Store Config
- iOS:
  - [ ] App Store Connect entry
  - [ ] Privacy (App Privacy section)
  - [ ] ATT prompt (if ads/IDFA)
  - [ ] Content rating form
- Android:
  - [ ] Play Console entry
  - [ ] Data Safety form
  - [ ] Ads disclosure
  - [ ] Content rating form

## Build & Packaging
- iOS:
  - [ ] Archive build in Xcode
  - [ ] Upload to App Store Connect (Transporter/Xcode)
- Android:
  - [ ] Generate release AAB
  - [ ] Sign with release key
  - [ ] Upload AAB to Play Console

## Testing & Validation
- iOS:
  - [ ] TestFlight tested
- Android:
  - [ ] Internal test track tested

## Final Pre-Review Checks
- [ ] Age rating confirmed (both)
- [ ] Monetization (ads, IAP) declared
- [ ] Screenshots + metadata consistent
- [ ] No debug builds or placeholder assets

## Copilot Translation Notes
- Treat sections as **boards**
- Treat `[ ]` lines as **tasks**
- Completed tasks → `[x]`
