# core_services_isar

<!-- Badges -->
<p>
          <a href="https://github.com/6hostsRus/flutter_game_ecosystem/blob/main/docs/METRICS.md">
               <img alt="Coverage (core_services_isar)" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/coverage_core_services_isar.json" />
          <img alt="Packages" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/packages.json" />
          <img alt="Stub parity" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/stub_parity.json" />
               <img alt="Analytics (core_services_isar)" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/analytics_core_services_isar.json" />
               <img alt="Pkg warnings (core_services_isar)" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/pkg_warn_core_services_isar.json" />
     </a>
</p>

Date: 2025-08-30

Optional Isar persistence for **Wallet** and **Idle** state.

## Usage

1. Add dependency:

```yaml
dependencies:
     core_services_isar:
          path: ../core_services_isar
```

2. Generate Isar code once:

```bash
cd /Users/Learn/Projects/flutter_game_ecosystem/packages/services/core_services_isar
flutter pub get
dart run build_runner build -d
```

3. Use in app:

```dart
final idleSvc = await ref.read(idleServiceIsarProvider.future);
final earned = await idleSvc.computeOfflineYield();
await idleSvc.grantCoins(earned);
```
