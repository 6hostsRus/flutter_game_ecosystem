import 'package:flutter/material.dart';

class StoreButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const StoreButton(
      {super.key,
      required this.label,
      this.icon = Icons.shopping_cart_rounded,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      key: const Key('store:button'),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
