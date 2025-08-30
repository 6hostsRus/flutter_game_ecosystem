
# core_services_isar
Date: 2025-08-30

Optional Isar persistence for **Wallet** and **Idle** state.

## Usage
1) Add dependency:
```yaml
dependencies:
  core_services_isar:
    path: ../core_services_isar
```

2) Generate Isar code once:
```bash
flutter pub get
dart run build_runner build -d
```

3) Use in app:
```dart
final idleSvc = await ref.read(idleServiceIsarProvider.future);
final earned = await idleSvc.computeOfflineYield();
await idleSvc.grantCoins(earned);
```
