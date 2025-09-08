import 'package:core_services/core_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:game_scenes/game_scenes.dart';
import 'package:ui_shell/ui_shell.dart';
import 'package:match/match.dart';
import 'package:survivor/survivor.dart';
import 'package:game_core/game_core.dart';
import 'package:idle/idle.dart';

void main() => runApp(const ProviderScope(child: App()));

final currencyProvider = walletProvider;
final appConfigProvider =
    Provider<AppConfig>((ref) => AppConfig.fromEnvironment());
// Optional: provide a persistent SaveDriver via SharedPreferences.
// Use [sharedPrefsSaveDriverProvider] to asynchronously obtain the driver,
// and [saveDriverProvider] to synchronously access a fallback (InMemory) while
// the async provider is initializing.
final sharedPrefsSaveDriverProvider = FutureProvider<SaveDriver>((ref) async {
  try {
    return await SharedPreferencesSaveDriver.create();
  } catch (_) {
    // If SharedPreferences is unavailable on the current platform, fall back.
    return InMemorySaveDriver();
  }
});

final saveDriverProvider = Provider<SaveDriver>((ref) {
  final async = ref.watch(sharedPrefsSaveDriverProvider);
  return async.maybeWhen(data: (d) => d, orElse: () => InMemorySaveDriver());
});
const bool kDemoMatchButton =
    bool.fromEnvironment('DEMO_MATCH_BUTTON', defaultValue: false);
final matchDemoEnabledProvider = Provider<bool>((ref) {
  final cfg = ref.watch(appConfigProvider);
  return cfg.featureMatch && kDemoMatchButton;
});
const bool kDemoSurvivorButton =
    bool.fromEnvironment('DEMO_SURVIVOR_BUTTON', defaultValue: false);
final survivorDemoEnabledProvider = Provider<bool>((ref) {
  final cfg = ref.watch(appConfigProvider);
  return cfg.featureSurvivor && kDemoSurvivorButton;
});
const bool kDemoIdleButton =
    bool.fromEnvironment('DEMO_IDLE_BUTTON', defaultValue: false);
final idleDemoEnabledProvider = Provider<bool>((ref) {
  final cfg = ref.watch(appConfigProvider);
  return cfg.featureIdle && kDemoIdleButton;
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
            Visibility(
              visible: ref.watch(idleDemoEnabledProvider),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const IdleDemoScreen(),
                      ),
                    ),
                    icon: const Icon(Icons.timelapse_rounded),
                    label: const Text('Play Idle (demo)'),
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
          Expanded(
            child: _SurvivorHudDemo(mode: mode),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('Mode: $mode', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}

class _SurvivorHudDemo extends StatefulWidget {
  final String mode;
  const _SurvivorHudDemo({required this.mode});
  @override
  State<_SurvivorHudDemo> createState() => _SurvivorHudDemoState();
}

class _SurvivorHudDemoState extends State<_SurvivorHudDemo>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  SurvivorRunState _state = const SurvivorRunState(
    health: 100,
    damagePerSec: 2,
    dpsGrowthPerWave: 0.15,
    spawnGrowthPerWave: 0.25,
  );

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      // ~60 FPS
      setState(() {
        _state = _state.tick(1 / 60);
      });
    })
      ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hpPct = (_state.health / 100).clamp(0.0, 1.0);
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Wave ${_state.wave}',
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: LinearProgressIndicator(
              value: hpPct,
              minHeight: 12,
              backgroundColor: Colors.red[200],
              color: Colors.greenAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text('HP: ${_state.health.toStringAsFixed(1)}',
              style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
              'DPS: ${_state.effectiveDps.toStringAsFixed(2)}  xSpawn: ${_state.spawnRateMultiplier.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class IdleDemoScreen extends StatefulWidget {
  const IdleDemoScreen({super.key});
  @override
  State<IdleDemoScreen> createState() => _IdleDemoScreenState();
}

class _IdleDemoScreenState extends State<IdleDemoScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late World _world;

  @override
  void initState() {
    super.initState();
    _world = World();
    // Create state entity
    final state = IdleState(softCurrency: 0.0, generators: [
      Generator(
          id: 'gen1', baseRatePerSec: 1.0, multiplier: 1.0, unlocked: true),
      Generator(
          id: 'gen2', baseRatePerSec: 0.2, multiplier: 1.0, unlocked: true),
    ]);
    final sEntity = _world.createEntity();
    sEntity.set<IdleStateComponentData>(state.toComponent());
    // Create generator entities
    for (final g in state.generators) {
      final e = _world.createEntity();
      e.set<GeneratorComponentData>(g.toComponent());
    }
    _ticker = createTicker((elapsed) {
      setState(() {
        IdleIncomeSystem.tick(_world, 1 / 60);
      });
    })
      ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = _world
        .query([IdleStateComponentData])
        .cast<Entity>()
        .first
        .get<IdleStateComponentData>()!;
    return Scaffold(
      appBar: AppBar(title: const Text('Idle Demo')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('ECS Idle Income Demo'),
            const SizedBox(height: 8),
            Text('Soft Currency: ${s.softCurrency.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
