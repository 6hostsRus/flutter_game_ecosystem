import 'package:flutter/material.dart';

enum GameTab { home, upgrades, items, store, quests }

extension GameTabX on GameTab {
  String get label => switch (this) {
        GameTab.home => 'Home',
        GameTab.upgrades => 'Upgrades',
        GameTab.items => 'Items',
        GameTab.store => 'Store',
        GameTab.quests => 'Quests',
      };

  IconData get icon => switch (this) {
        GameTab.home => Icons.dashboard_rounded,
        GameTab.upgrades => Icons.auto_awesome_rounded,
        GameTab.items => Icons.inventory_2_rounded,
        GameTab.store => Icons.store_rounded,
        GameTab.quests => Icons.flag_rounded,
      };
}
