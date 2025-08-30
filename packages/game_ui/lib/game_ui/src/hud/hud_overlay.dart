import 'package:flutter/material.dart';

class HudOverlay extends StatelessWidget {
  final List<Widget> leading;
  final List<Widget> trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const HudOverlay({
    super.key,
    required this.child,
    this.leading = const [],
    this.trailing = const [],
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: child),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: Padding(
            padding: padding,
            child: Row(
              children: [
                ...leading,
                const Spacer(),
                ...trailing,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
