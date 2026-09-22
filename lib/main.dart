import 'package:flutter/material.dart';

import 'game/controller.dart';
import 'ui/game_screen.dart';
import 'ui/setup_screen.dart';

void main() => runApp(const ChainReactionApp());

class ChainReactionApp extends StatefulWidget {
  const ChainReactionApp({super.key});

  @override
  State<ChainReactionApp> createState() => _ChainReactionAppState();
}

class _ChainReactionAppState extends State<ChainReactionApp> {
  var settings = const GameSettings(players: 2, cols: 6, rows: 9);
  var playing = false;
  var round = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chain Reaction',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBackground,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          surface: Color(0xFF1C1D27),
        ),
      ),
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: playing
            ? GameScreen(
                key: ValueKey(round),
                settings: settings,
                onRestart: () => setState(() => round++),
                onExit: () => setState(() => playing = false),
              )
            : SetupScreen(
                key: const ValueKey('setup'),
                initial: settings,
                onStart: (s) => setState(() {
                  settings = s;
                  playing = true;
                  round++;
                }),
              ),
      ),
    );
  }
}
