import 'package:flutter/material.dart';
import 'package:flutter_chain_reaction/services/index.dart';
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
      const margin = 50.0;
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
          margin: const EdgeInsets.only(
            top: margin,
          ),
          padding: const EdgeInsets.all(gutter),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: width / boardSize,
              childAspectRatio: itemWidth / itemHeight,
              crossAxisSpacing: gutter,
              mainAxisSpacing: gutter,
            ),
            itemCount: store.tiles.length,
            itemBuilder: (BuildContext ctx, index) {
              return Observer(builder: (context) {
                final tile = store.tiles[index];
                logger.d('BUILD:Tile[$index]');
                return GameTileWidget(
                  size: itemWidth * 0.3,
                  tile: tile,
                  parentSize: Size(itemWidth, itemHeight),
                  onTap: () => store.play(index),
                );
              });
            },
          ),
        ),
      );
    });
  }
}
