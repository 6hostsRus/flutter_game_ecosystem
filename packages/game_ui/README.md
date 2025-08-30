# game_ui
Date: 2025-08-30

Reusable, opinionated UI widgets for Flutter/Flame game apps:
- Bottom Navigation Scaffold (Home, Upgrades, Items, Store, Quests)
- HUD overlay (top bar with currency/timers)
- Cards for Upgrades/Items
- Store button
- Theme tokens

## Example
```dart
return GameNavScaffold(
  tabs: {
    GameTab.home: (_) => const Center(child: Text('Home')),
    GameTab.upgrades: (_) => const Center(child: Text('Upgrades')),
    GameTab.items: (_) => const Center(child: Text('Items')),
    GameTab.store: (_) => const Center(child: Text('Store')),
    GameTab.quests: (_) => const Center(child: Text('Quests')),
  },
);
```

## Theming
```dart
ThemeData(
  extensions: const <ThemeExtension<dynamic>>[ GameTokens(hudPadding: 8) ],
);
```
