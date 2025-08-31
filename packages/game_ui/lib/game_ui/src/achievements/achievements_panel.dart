import 'package:flutter/material.dart';

class Achievement {
  final String title;
  final String subtitle;
  final bool unlocked;

  const Achievement(
      {required this.title, required this.subtitle, this.unlocked = false});
}

class AchievementsPanel extends StatelessWidget {
  final List<Achievement> items;
  const AchievementsPanel({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final a = items[i];
        return ListTile(
          leading: Icon(a.unlocked
              ? Icons.emoji_events_rounded
              : Icons.lock_outline_rounded),
          title: Text(a.title),
          subtitle: Text(a.subtitle),
          trailing: a.unlocked
              ? const Icon(Icons.check_circle, color: Colors.green)
              : null,
        );
      },
    );
  }
}
