// import 'package:core_services/core_services.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:game_ui/game_ui.dart';

// void main() => runApp(const ProviderScope(child: App()));

// final currencyProvider = walletProvider;

// class App extends ConsumerWidget {
//   const App({super.key});
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return MaterialApp(
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
//         useMaterial3: true,
//         extensions: const [GameTokens(hudPadding: 8)],
//       ),
//       home: GameNavScaffold(
//         tabs: {
//           GameTab.home: (_) => HomeScreen(),
//           GameTab.upgrades: (_) => UpgradesScreen(),
//           GameTab.items: (_) => ItemsScreen(),
//           GameTab.store: (_) => StoreScreen(),
//           GameTab.quests: (_) => QuestsScreen(),
//         },
//       ),
//     );
//   }
// }

// class HomeScreen extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final coins = ref.watch(currencyProvider).coins;
//     return HudOverlay(
//       child: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text('Home — Demo Game'),
//             const SizedBox(height: 16),
//             FilledButton.icon(
//               onPressed: () => Navigator.of(context).push(MaterialPageRoute(
//                   builder: (_) => Scaffold(
//                       appBar: AppBar(title: const Text('Platformer')),
//                       body: platformerWidget()))),
//               icon: const Icon(Icons.gamepad_rounded),
//               label: const Text('Play Platformer (stub)'),
//             ),
//             const SizedBox(height: 8),
//             FilledButton.icon(
//               onPressed: () => Navigator.of(context).push(MaterialPageRoute(
//                   builder: (_) => Scaffold(
//                       appBar: AppBar(title: const Text('Survivor')),
//                       body: survivorWidget()))),
//               icon: const Icon(Icons.auto_awesome_rounded),
//               label: const Text('Play Survivor (stub)'),
//             ),
//           ],
//         ),
//       ),
//       trailing: [
//         CurrencyBadge(
//             icon: Icons.monetization_on_rounded,
//             value: coins.toStringAsFixed(0),
//             tooltip: 'Coins'),
//       ],
//     );
//   }
// }

// class UpgradesScreen extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final coins = ref.watch(currencyProvider).coins;
//     List<(String, String, String)> items = [
//       ('Double Income', 'Increase idle yield by 100%', '50'),
//       ('Auto Collect', 'Collect idle every minute', '75'),
//       ('Crit Chance', '+5% crit for survivor-like', '30'),
//     ];
//     return ListView.builder(
//       padding: const EdgeInsets.all(12),
//       itemCount: items.length,
//       itemBuilder: (context, i) {
//         final it = items[i];
//         final cost = double.parse(it.$3);
//         return UpgradeCard(
//           title: it.$1,
//           subtitle: it.$2,
//           costText: it.$3,
//           disabled: coins < cost,
//           onPressed: coins >= cost
//               ? () {
//                   final ok =
//                       ref.read(currencyProvider.notifier).spendCoins(cost);
//                   if (!ok) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Not enough coins')));
//                     return;
//                   }
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Purchased ${it.$1}')));
//                 }
//               : null,
//         );
//       },
//     );
//   }
// }

// class ItemsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(12),
//       children: const [
//         ItemCard(title: 'Iron Sword', subtitle: '+5 ATK'),
//         ItemCard(title: 'Explorer Boots', subtitle: '+1 Jump'),
//       ],
//     );
//   }
// }

// class StoreScreen extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Center(
//       child: StoreButton(
//         label: 'Open Store',
//         onPressed: () {
//           showStoreSheet(context, items: [
//             StoreItem(
//                 title: 'Coin Pack S',
//                 subtitle: 'Add 100 coins',
//                 priceText: '\$0.99',
//                 onBuy: () {
//                   ref.read(currencyProvider.notifier).addCoins(100);
//                   Navigator.of(context).pop();
//                 }),
//             StoreItem(
//                 title: 'Coin Pack M',
//                 subtitle: 'Add 300 coins',
//                 priceText: '\$1.99',
//                 onBuy: () {
//                   ref.read(currencyProvider.notifier).addCoins(300);
//                   Navigator.of(context).pop();
//                 }),
//           ]);
//         },
//       ),
//     );
//   }
// }

// class QuestsScreen extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return QuestsPanel(
//       quests: [
//         Quest(
//             title: 'Log in',
//             description: 'Open the app today',
//             progress: 1,
//             claimable: true,
//             onClaim: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Claimed 50 coins!')));
//               ref.read(currencyProvider.notifier).addCoins(50);
//             }),
//         const Quest(
//             title: 'Play a run',
//             description: 'Finish one survivor run',
//             progress: 0.2),
//         const Quest(
//             title: 'Upgrade an item',
//             description: 'Buy one upgrade',
//             progress: 0.0),
//       ],
//     );
//   }
// }
