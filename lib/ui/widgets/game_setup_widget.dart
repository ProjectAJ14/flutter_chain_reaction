import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:neopop/neopop.dart';
import 'package:provider/provider.dart';

import '../../model/board_size.dart';
import '../../store/game_store.dart';

class GameSetupWidget extends StatelessWidget {
  const GameSetupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<GameStore>(context);
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.maxHeight;
      final width = constraints.maxWidth;
      const gutter = 2.0;
      final gutterSpacingW = gutter * (store.boardSize.width + 1);
      final gutterSpacingH = gutter * (store.boardSize.height + 1);
      final itemWidth = (width - gutterSpacingW) / store.boardSize.width;
      final itemHeight = (height - gutterSpacingH) / store.boardSize.height;

      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black,
                ],
                radius: 2.5,
              ),
            ),
          ),
          Observer(builder: (context) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: width / store.boardSize.width,
                childAspectRatio: itemWidth / itemHeight,
                crossAxisSpacing: gutter,
                mainAxisSpacing: gutter,
              ),
              itemCount: store.boardSize.width * store.boardSize.height,
              itemBuilder: (BuildContext ctx, index) {
                return Container(
                  color: Colors.black,
                );
              },
            );
          }),
          Observer(builder: (context) {
            return Container(
              color: Colors.transparent,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth > constraints.maxHeight
                        ? constraints.maxWidth * 0.2
                        : constraints.maxWidth * 0.1,
                  ),
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image(
                          height: math.min(
                            constraints.maxWidth / 10,
                            constraints.maxHeight / 10,
                          ),
                          image: const AssetImage(
                            'assets/ns-logo-dark-f.png',
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Chain Reaction',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: constraints.maxWidth * 0.05,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Players',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: constraints.maxWidth * 0.03,
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
                          fontSize: constraints.maxWidth * 0.03,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CupertinoSegmentedControl<BoardSize>(
                      unselectedColor: Colors.black,
                      children: const {
                        BoardSize(6, 9): Text(
                          '6X9',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        BoardSize(5, 8): Text(
                          '5X8',
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
                      child: NeoPopTiltedButton(
                        color: Colors.white,
                        onTapUp: store.init,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 10,
                          ),
                          child: Text('PLAY'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      );
    });
  }
}
