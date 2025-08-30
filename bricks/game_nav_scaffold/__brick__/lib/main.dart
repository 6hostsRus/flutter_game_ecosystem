import 'package:flutter/material.dart';
import 'package:game_ui/game_ui.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        extensions: const [GameTokens(hudPadding: 8)],
      ),
      home: GameNavScaffold(
        tabs: {
          GameTab.home: (_) => const Center(child: Text('Home')),
          GameTab.upgrades: (_) => const Center(child: Text('Upgrades')),
          GameTab.items: (_) => const Center(child: Text('Items')),
          GameTab.store: (_) => const Center(child: Text('Store')),
          GameTab.quests: (_) => const Center(child: Text('Quests')),
        },
      ),
    );
  }
}
