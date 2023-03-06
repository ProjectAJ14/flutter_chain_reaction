import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chain_reaction/ui/widgets/blast_widget.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../model/game_tile.dart';
import '../../store/game_store.dart';
import 'game_icon_widget.dart';

class GameTileWidget extends StatelessWidget {
  const GameTileWidget({
    super.key,
    required this.size,
    required this.tile,
    required this.onTap,
    required this.parentSize,
  });

  final double size;
  final GameTile tile;
  final Size parentSize;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (kDebugMode)
              Observer(builder: (context) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    tile.info(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.3,
                    ),
                  ),
                );
              }),
            Center(
              child: GameIconWidget(
                size: size,
                tile: tile,
                parentSize: parentSize,
              ),
            ),
            Observer(builder: (context) {
              final store = Provider.of<GameStore>(context);
              if (!tile.isBlasted) {
                return const SizedBox();
              }
              return BlastWidget(
                color: store.byPlayerIndex(tile.blastPlayerIndex),
              );
            })
          ],
        ),
      ),
    );
  }
}
