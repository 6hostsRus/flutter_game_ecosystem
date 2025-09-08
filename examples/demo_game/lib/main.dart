import 'package:core_services/core_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_scenes/game_scenes.dart';
import 'package:ui_shell/ui_shell.dart';
import 'package:match/match.dart';
import 'package:game_core/game_core.dart';

void main() => runApp(const ProviderScope(child: App()));

final currencyProvider = walletProvider;
final appConfigProvider =
    Provider<AppConfig>((ref) => AppConfig.fromEnvironment());
const bool kDemoMatchButton =
    bool.fromEnvironment('DEMO_MATCH_BUTTON', defaultValue: false);
final matchDemoEnabledProvider = Provider<bool>((ref) {
  final cfg = ref.watch(appConfigProvider);
  return cfg.featureMatch && kDemoMatchButton;
});

class App extends ConsumerWidget {
  final String? initialRoute;
  const App({super.key, this.initialRoute});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      initialRoute: initialRoute,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        extensions: const [GameTokens(hudPadding: 8)],
      ),
      onGenerateInitialRoutes: (initialRoute) {
        // Handle initial route explicitly so unknown routes don't throw and instead
        // render the main scaffold (home fallback). Support /play/<mode> deep links.
        String route = initialRoute;
        if (route == '/' || route.isEmpty) {
          return [
            MaterialPageRoute(
              builder: (_) => GameNavScaffold(
                tabs: {
                  GameTab.home: (_) => const HomeScreen(),
                  GameTab.upgrades: (_) => const UpgradesScreen(),
                  GameTab.items: (_) => const ItemsScreen(),
                  GameTab.store: (_) => const StoreScreen(),
                  GameTab.quests: (_) => const QuestsScreen(),
                },
              ),
              settings: const RouteSettings(name: '/'),
            ),
          ];
        }
        if (route.startsWith('/play/')) {
          final mode = route.substring('/play/'.length).trim();
          return [
            MaterialPageRoute(
              builder: (_) =>
                  SurvivorScreen(mode: mode.isEmpty ? 'normal' : mode),
              settings: RouteSettings(name: route),
            ),
          ];
        }
        // Unknown initial route: fall back to home scaffold instead of throwing.
        return [
          MaterialPageRoute(
            builder: (_) => GameNavScaffold(
              tabs: {
                GameTab.home: (_) => const HomeScreen(),
                GameTab.upgrades: (_) => const UpgradesScreen(),
                GameTab.items: (_) => const ItemsScreen(),
                GameTab.store: (_) => const StoreScreen(),
                GameTab.quests: (_) => const QuestsScreen(),
              },
            ),
            settings: const RouteSettings(name: '/'),
          ),
        ];
      },
      onGenerateRoute: (settings) {
        final name = settings.name;
        if (name != null && name.startsWith('/play/')) {
          final mode = name.substring('/play/'.length).trim();
          return MaterialPageRoute(
            builder: (_) =>
                SurvivorScreen(mode: mode.isEmpty ? 'normal' : mode),
            settings: settings,
          );
        }
        return null; // fallback to home scaffold below
      },
      onUnknownRoute: (settings) {
        // Gracefully fallback to the home scaffold for unknown named routes.
        return MaterialPageRoute(
          builder: (_) => GameNavScaffold(
            tabs: {
              GameTab.home: (_) => const HomeScreen(),
              GameTab.upgrades: (_) => const UpgradesScreen(),
              GameTab.items: (_) => const ItemsScreen(),
              GameTab.store: (_) => const StoreScreen(),
              GameTab.quests: (_) => const QuestsScreen(),
            },
          ),
          settings: settings,
        );
      },
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coins = ref.watch(currencyProvider).coins;
    return HudOverlay(
      trailing: [
        CurrencyBadge(
            icon: Icons.monetization_on_rounded,
            value: coins.toStringAsFixed(0),
            tooltip: 'Coins'),
      ],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Home — Demo Game'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => Scaffold(
                      appBar: AppBar(title: const Text('Platformer')),
                      body: platformerWidget()))),
              icon: const Icon(Icons.gamepad_rounded),
              label: const Text('Play Platformer (stub)'),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pushNamed('/play/normal'),
              icon: const Icon(Icons.auto_awesome_rounded),
              label: const Text('Play Survivor (stub)'),
            ),
            Visibility(
              visible: ref.watch(matchDemoEnabledProvider),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          appBar: AppBar(title: const Text('Match-3 Demo')),
                          body: const Center(
                            child: MatchBoardView(
                              width: 8,
                              height: 8,
                              kinds: 6,
                              seed: 42,
                              cellSize: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.grid_on_rounded),
                    label: const Text('Play Match-3 (demo)'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpgradesScreen extends ConsumerWidget {
  const UpgradesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coins = ref.watch(currencyProvider).coins;
    final items = <(String title, String description, String price)>[
      ('Double Income', 'Increase idle yield by 100%', '50'),
      ('Auto Collect', 'Collect idle every minute', '75'),
      ('Crit Chance', '+5% crit for survivor-like', '30'),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final it = items[index];
        final cost = double.tryParse(it.$3) ?? 0;
        final canAfford = coins >= cost;
        return Card(
          child: ListTile(
            title: Text(it.$1),
            subtitle: Text(it.$2),
            trailing: FilledButton(
              onPressed: canAfford
                  ? () {
                      final ok =
                          ref.read(currencyProvider.notifier).spendCoins(cost);
                      if (!ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Not enough coins')),
                        );
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Purchased ${it.$1}')),
                      );
                    }
                  : null,
              child: Text('${it.$3}c'),
            ),
          ),
        );
      },
    );
  }
}

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: const [
        ItemCard(title: 'Iron Sword', subtitle: '+5 ATK'),
        ItemCard(title: 'Explorer Boots', subtitle: '+1 Jump'),
      ],
    );
  }
}

class StoreScreen extends ConsumerWidget {
  const StoreScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: StoreButton(
        label: 'Open Store',
        onPressed: () {
          showStoreSheet(context, items: [
            StoreItem(
                title: 'Coin Pack S',
                subtitle: 'Add 100 coins',
                priceText: '\$0.99',
                onBuy: () {
                  ref.read(currencyProvider.notifier).addCoins(100);
                  Navigator.of(context).pop();
                }),
            StoreItem(
                title: 'Coin Pack M',
                subtitle: 'Add 300 coins',
                priceText: '\$1.99',
                onBuy: () {
                  ref.read(currencyProvider.notifier).addCoins(300);
                  Navigator.of(context).pop();
                }),
          ]);
        },
      ),
    );
  }
}

class QuestsScreen extends ConsumerWidget {
  const QuestsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuestsPanel(
      quests: [
        Quest(
            title: 'Log in',
            description: 'Open the app today',
            progress: 1,
            claimable: true,
            onClaim: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Claimed 50 coins!')));
              ref.read(currencyProvider.notifier).addCoins(50);
            }),
        const Quest(
            title: 'Play a run',
            description: 'Finish one survivor run',
            progress: 0.2),
        const Quest(
            title: 'Upgrade an item',
            description: 'Buy one upgrade',
            progress: 0.0),
      ],
    );
  }
}

class SurvivorScreen extends StatelessWidget {
  final String mode;
  const SurvivorScreen({super.key, required this.mode});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Survivor')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: survivorWidget()),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('Mode: $mode', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
