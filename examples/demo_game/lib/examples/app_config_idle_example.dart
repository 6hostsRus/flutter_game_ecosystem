import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';

/// Minimal example showing conditional UI using AppConfig flags.
class AppConfigIdleExample extends StatelessWidget {
  final AppConfig config;
  const AppConfigIdleExample({super.key, this.config = const AppConfig()});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('AppConfig Example')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Idle enabled: ${config.featureIdle}'),
              const SizedBox(height: 12),
              if (config.featureIdle)
                const Text('Idle tab would appear here')
              else
                const Text('Idle features are disabled'),
            ],
          ),
        ),
      ),
    );
  }
}
