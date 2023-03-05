import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../store/game_store.dart';

class GameOverWidget extends StatelessWidget {
  const GameOverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<GameStore>(context);
    return LayoutBuilder(builder: (context, constrains) {
      return Container(
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
              child: ElevatedButton(
                onPressed: store.reset,
                child: const Text('Play again'),
              ),
            ),
          ],
        ),
      );
    });
  }
}
