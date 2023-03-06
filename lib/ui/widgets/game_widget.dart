import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../model/board_size.dart';
import '../../store/game_store.dart';
import 'game_tile_widget.dart';

class GameWidget extends StatelessWidget {
  const GameWidget({
    super.key,
    required this.boardSize,
    required this.color,
  });

  final Color color;
  final BoardSize boardSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.maxHeight;
      final width = constraints.maxWidth;
      const gutter = 4.0;
      const margin = 80.0;
      final gutterSpacingW = gutter * (boardSize.width + 1);
      final gutterSpacingH = gutter * (boardSize.height + 1);
      final itemWidth = (width - gutterSpacingW) / boardSize.width;
      final itemHeight = (height - gutterSpacingH - margin) / boardSize.height;
      final store = Provider.of<GameStore>(context);
      return Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              color.withOpacity(0.5),
              color,
            ],
          ),
        ),
        child: Container(
          color: Colors.white10,
          padding: const EdgeInsets.all(gutter),
          child: Column(
            children: [
              SizedBox(
                height: margin,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: store.reset,
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Observer(builder: (context) {
                      //Show score
                      final players = store.players;
                      return Text(
                        players.map((e) => e.score).toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      );
                    }),
                    Observer(builder: (context) {
                      final players = store.players;
                      //Show score
                      final tiles = store.tiles;
                      var list = [];
                      for (int i = 0; i < players.length; i++) {
                        int count = 0;
                        for (var tile in tiles) {
                          if (tile.playerIndex == i) {
                            count = count + tile.value;
                          }
                        }
                        list.add(count);
                      }

                      return Text(
                        list.map((e) => e).toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Observer(builder: (context) {
                final tiles = store.tiles;
                return Flexible(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: width / boardSize.width,
                      childAspectRatio: itemWidth / itemHeight,
                      crossAxisSpacing: gutter,
                      mainAxisSpacing: gutter,
                    ),
                    itemCount: tiles.length,
                    itemBuilder: (BuildContext ctx, index) {
                      final tile = tiles[index];
                      return GameTileWidget(
                        size: (math.min(itemHeight, itemWidth)) * 0.3,
                        tile: tile,
                        parentSize: Size(itemWidth, itemHeight),
                        onTap: () => store.play(index),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}
