import 'package:flutter/material.dart';
import 'dart:async';

class TimerBadge extends StatefulWidget {
  final Duration duration;
  final VoidCallback? onComplete;

  const TimerBadge({super.key, required this.duration, this.onComplete});

  @override
  State<TimerBadge> createState() => _TimerBadgeState();
}

class _TimerBadgeState extends State<TimerBadge> {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remaining -= const Duration(seconds: 1);
        if (_remaining.isNegative || _remaining == Duration.zero) {
          _timer?.cancel();
          widget.onComplete?.call();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = _two(_remaining.inMinutes.remainder(60)) +
        ":" +
        _two(_remaining.inSeconds.remainder(60));
    return Chip(label: Text(text));
  }

  String _two(int v) => v.toString().padLeft(2, '0');
}
