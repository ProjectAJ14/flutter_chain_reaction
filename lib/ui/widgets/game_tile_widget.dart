import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// flutter_animate
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_chain_reaction/ui/widgets/blast_widget.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:neopop/neopop.dart' as neo;

import '../../model/game_tile.dart';
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
    return neo.NeoPopButton(
      onTapUp: onTap,
      color: Colors.black,
      parentColor: Colors.transparent,
      buttonPosition: neo.Position.center,
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
              child: tile.canBlast
                  ? Animate(
                      delay: const Duration(milliseconds: 100),
                      effects: [
                        ShakeEffect(
                          hz: size / 4,
                          offset: Offset(size / 4, 0),
                        ),
                      ],
                      child: GameIconWidget(
                        size: size,
                        tile: tile,
                        parentSize: parentSize,
                      ),
                    )
                  : GameIconWidget(
                      size: size,
                      tile: tile,
                      parentSize: parentSize,
                    ),
            ),
            Observer(builder: (context) {
              if (!tile.isBlasted) {
                return const SizedBox();
              }
              return BlastWidget(
                size: parentSize,
                index: tile.blastPlayerIndex,
              );
            })
          ],
        ),
      ),
    );
  }
}
