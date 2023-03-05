import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../store/game_store.dart';
import 'game_tile_widget.dart';

class GameWidget extends StatelessWidget {
  const GameWidget({
    super.key,
    required this.boardSize,
    required this.color,
  });

  final Color color;
  final int boardSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.maxHeight;
      final width = constraints.maxWidth;
      const gutter = 4.0;
      const margin = 80.0;
      final gutterSpacing = gutter * (boardSize + 1);
      final itemWidth = (width - gutterSpacing) / boardSize;
      final itemHeight = (height - gutterSpacing - margin) / boardSize;
      final store = Provider.of<GameStore>(context);
      return Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.grey.withOpacity(0.9), color],
            radius: 1,
            focal: Alignment.topCenter,
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
                    )
                  ],
                ),
              ),
              Observer(builder: (context) {
                final tiles = store.tiles;
                return Flexible(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: width / boardSize,
                      childAspectRatio: itemWidth / itemHeight,
                      crossAxisSpacing: gutter,
                      mainAxisSpacing: gutter,
                    ),
                    itemCount: tiles.length,
                    itemBuilder: (BuildContext ctx, index) {
                      final tile = tiles[index];
                      return GameTileWidget(
                        size: itemWidth * 0.3,
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
