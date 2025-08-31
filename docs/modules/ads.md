# Ads Module (V1)

## Purpose
Centralize ad initialization, loading, show rules, and reward callbacks.

## Dependencies
- `google_mobile_ads`

## API (sketch)
```dart
typedef RewardHandler = void Function(String rewardId, {int amount});
class AdService {
  Future<void> init();
  Future<bool> preloadInterstitial(String id);
  Future<bool> showInterstitial(String id);
  Future<bool> preloadRewarded(String id);
  Future<bool> showRewarded(String id, RewardHandler onReward);
}
```

## Policy
- **Frequency capping** + cool‑downs.
- **Fail‑soft**: never block core loop if ad fails.
- **Experiment flags**: enable/disable placements at runtime.

## Placements (templates)
- Runner: rewarded retry, interstitial on game‑over, banner on menus.
- Shooter: rewarded revive, interstitial between stages.
- Match‑3: rewarded extra moves, interstitial after N levels.

## Deliverables (v1)
- Wrapper service + simple placement manager
- Reward bus with typed events
