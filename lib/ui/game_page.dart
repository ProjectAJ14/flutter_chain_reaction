import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../services/index.dart';
import '../store/game_store.dart';
import 'widgets/game_over_widget.dart';
import 'widgets/game_widget.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    const boardSize = 15;
    return Provider(
      create: (context) => GameStore()..init(boardSize),
      child: Scaffold(
        body: Stack(
          children: [
            Observer(
              builder: (context) {
                logger.d('BUILD:GameWidget');
                final store = Provider.of<GameStore>(context);
                return Stack(
                  children: [
                    GameWidget(
                      boardSize: boardSize,
                      color: store.currentPlayerColor,
                    ),
                    if (store.hasWinner) const GameOverWidget(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
