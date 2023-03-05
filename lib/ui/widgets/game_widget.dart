import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../store/game_store.dart';
import 'game_tile_widget.dart';

class GameWidget extends StatelessWidget {
  const GameWidget({
    super.key,
    required this.crossAxisCount,
    required this.color,
  });

  final Color color;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const gutter = 4.0;
    const margin = 50.0;
    final gutterSpacing = gutter * (crossAxisCount + 1);
    final itemWidth = (size.width - gutterSpacing) / crossAxisCount;
    final itemHeight = (size.height - gutterSpacing - margin) / crossAxisCount;

    return Observer(builder: (context) {
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
              maxCrossAxisExtent: size.width / crossAxisCount,
              childAspectRatio: itemWidth / itemHeight,
              crossAxisSpacing: gutter,
              mainAxisSpacing: gutter,
            ),
            itemCount: store.tiles.length,
            itemBuilder: (BuildContext ctx, index) {
              final tile = store.tiles[index];
              return GameTileWidget(
                size: itemWidth * 0.4,
                tile: tile,
                parentSize: Size(itemWidth, itemHeight),
                onTap: () async {
                  int result = await store.play(index);
                  if (result != -1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Player ${result + 1} won!'),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      );
    });
  }
}
