import 'package:flutter/material.dart';

class UpgradeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String costText;
  final VoidCallback? onPressed;
  final bool disabled;

  const UpgradeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.costText,
    this.onPressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: disabled ? null : onPressed,
              child: Text(costText),
            ),
          ],
        ),
      ),
    );
  }
}
