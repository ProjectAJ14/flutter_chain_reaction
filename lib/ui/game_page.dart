import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../store/game_store.dart';
import 'widgets/game_over_widget.dart';
import 'widgets/game_setup_widget.dart';
import 'widgets/game_widget.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => GameStore(),
      child: Scaffold(
        body: Observer(
          builder: (context) {
            final store = Provider.of<GameStore>(context);
            if (store.status == GameStatus.init) {
              return const GameSetupWidget();
            }
            return Stack(
              children: [
                GameWidget(
                  boardSize: store.boardSize,
                  color: store.currentPlayerColor,
                ),
                if (store.hasWinner) const GameOverWidget(),
              ],
            );
          },
        ),
      ),
    );
  }
}
