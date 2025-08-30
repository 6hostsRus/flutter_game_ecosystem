import 'package:flutter/material.dart';
import 'package:game_ui/game_ui.dart';

class UpgradePanel extends StatelessWidget {
  final List<(String title, String subtitle, String cost)> items;
  final void Function(int index)? onBuy;

  const UpgradePanel({super.key, required this.items, this.onBuy});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final it = items[i];
        return UpgradeCard(
          title: it.$1,
          subtitle: it.$2,
          costText: it.$3,
          onPressed: onBuy == null ? null : () => onBuy!(i),
        );
      },
    );
  }
}
