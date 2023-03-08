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
      const gutter = 2.0;
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
              const SizedBox(width: 10),
              SizedBox(
                height: margin,
                child: Row(
                  children: [
                    Observer(builder: (context) {
                      return SizedBox(
                          width: margin / 2,
                          height: margin / 2,
                          child: store.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const SizedBox.shrink());
                    }),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Expanded(
                            child: Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/ns-logo-dark-f.png',
                                ),
                                height: margin / 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
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
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: width / boardSize.width,
                    childAspectRatio: itemWidth / itemHeight,
                    crossAxisSpacing: gutter,
                    mainAxisSpacing: gutter,
                  ),
                  itemCount: store.tiles.length,
                  itemBuilder: (BuildContext ctx, index) {
                    final tile = store.tiles[index];
                    return GameTileWidget(
                      size: (math.min(itemHeight, itemWidth)) * 0.4,
                      tile: tile,
                      parentSize: Size(itemWidth, itemHeight),
                      onTap: () => store.play(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
