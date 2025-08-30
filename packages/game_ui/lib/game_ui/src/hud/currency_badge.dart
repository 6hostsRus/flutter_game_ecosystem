import 'package:flutter/material.dart';

class CurrencyBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String? tooltip;
  final VoidCallback? onTap;

  const CurrencyBadge({
    super.key,
    required this.icon,
    required this.value,
    this.tooltip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chip = Chip(
      avatar: Icon(icon, size: 18),
      label: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
    );
    return GestureDetector(
      onTap: onTap,
      child: tooltip != null
          ? Tooltip(message: tooltip!, child: chip)
          : chip,
    );
  }
}
