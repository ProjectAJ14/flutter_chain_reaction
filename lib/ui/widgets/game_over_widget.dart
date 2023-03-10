import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';
import 'package:provider/provider.dart';

import './winner_confetti.dart';
import '../../store/game_store.dart';

class GameOverWidget extends StatelessWidget {
  const GameOverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<GameStore>(context);
    return LayoutBuilder(builder: (context, constrains) {
      return Stack(
        children: [
          WinnerConfetti.show(context),
          Container(
            color: store.winner.color.withOpacity(0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    '${store.winner.name} wins',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: constrains.maxWidth * 0.1,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: NeoPopTiltedButton(
                    color: Colors.white,
                    onTapUp: store.reset,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 10,
                      ),
                      child: Text('PLAY AGAIN'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
