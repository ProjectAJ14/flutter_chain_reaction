import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../store/game_store.dart';

class GameSetupWidget extends StatelessWidget {
  const GameSetupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<GameStore>(context);
    return LayoutBuilder(builder: (context, constrains) {
      return Observer(builder: (context) {
        return Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'NonStop Chain Reaction',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: constrains.maxWidth * 0.05,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Players',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: constrains.maxWidth * 0.03,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CupertinoSegmentedControl<int>(
                unselectedColor: Colors.black,
                children: const {
                  2: Text(
                    'TWO',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  3: Text(
                    'THREE',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  4: Text(
                    'FOUR',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  5: Text(
                    'FIVE',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  6: Text(
                    'SIX',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  7: Text(
                    'SEVEN',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  8: Text(
                    'EIGHT',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                },
                onValueChanged: (value) => store.setPlayerCount(value),
                groupValue: store.playerCount,
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Board Size',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: constrains.maxWidth * 0.03,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CupertinoSegmentedControl<int>(
                unselectedColor: Colors.black,
                children: const {
                  5: Text(
                    'SMALL',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  10: Text(
                    'MEDIUM',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  15: Text(
                    'LARGE',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                },
                onValueChanged: (value) => store.setBoardSize(value),
                groupValue: store.boardSize,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: store.init,
                  child: const Text('PLAY'),
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
