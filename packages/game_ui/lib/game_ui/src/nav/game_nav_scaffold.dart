import 'package:flutter/material.dart';
import 'nav_items.dart';

typedef TabBuilder = Widget Function(BuildContext context);

class GameNavScaffold extends StatefulWidget {
  final Map<GameTab, TabBuilder> tabs;
  final GameTab initialTab;
  final void Function(GameTab tab)? onTabSelected;
  final bool showLabels;

  const GameNavScaffold({
    super.key,
    required this.tabs,
    this.initialTab = GameTab.home,
    this.onTabSelected,
    this.showLabels = false,
  });

  @override
  State<GameNavScaffold> createState() => _GameNavScaffoldState();
}

class _GameNavScaffoldState extends State<GameNavScaffold> {
  late GameTab _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.tabs.entries.toList()
      ..sort((a, b) => a.key.index.compareTo(b.key.index));

    final currentBuilder = entries.firstWhere((e) => e.key == _current).value;

    return Scaffold(
      body: SafeArea(child: currentBuilder(context)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _current.index,
        destinations: [
          for (final e in entries)
            NavigationDestination(
              icon: Icon(e.key.icon),
              label: widget.showLabels ? e.key.label : '',
            ),
        ],
        onDestinationSelected: (i) {
          final next = entries[i].key;
          if (next != _current) {
            setState(() => _current = next);
            widget.onTabSelected?.call(next);
          }
        },
      ),
    );
  }
}
