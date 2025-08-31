import 'package:flutter/material.dart';
import '../hud/progress_bar.dart';

class Quest {
  final String title;
  final String description;
  final double progress; // 0..1
  final bool claimable;
  final VoidCallback? onClaim;

  const Quest(
      {required this.title,
      required this.description,
      required this.progress,
      this.claimable = false,
      this.onClaim});
}

class QuestsPanel extends StatelessWidget {
  final List<Quest> quests;
  const QuestsPanel({super.key, required this.quests});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: quests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final q = quests[i];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(q.title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(q.description,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                ProgressBar(value: q.progress),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.tonal(
                    onPressed: q.claimable ? q.onClaim : null,
                    child: const Text('Claim'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
