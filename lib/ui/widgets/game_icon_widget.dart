import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../model/game_tile.dart';
import '../../store/game_store.dart';

class GameIconWidget extends StatelessWidget {
  const GameIconWidget({
    super.key,
    required this.size,
    required this.tile,
    required this.parentSize,
  });

  final double size;
  final GameTile tile;
  final Size parentSize;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final store = Provider.of<GameStore>(context);
      final icon = Icon(
        Icons.circle,
        color: store.byPlayerIndex(tile.playerIndex),
        size: size,
      );

      final centerTop = parentSize.height / 2 - size / 2;
      final centerSide = parentSize.width / 2 - size / 2;
      final displacement = size / 3;

      switch (tile.value) {
        case 0:
          return Container();
        case 1:
          return icon;
        case 2:
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            fit: StackFit.passthrough,
            children: [
              Positioned(
                top: centerTop,
                left: centerSide - displacement,
                child: icon,
              ),
              Positioned(
                top: centerTop,
                left: centerSide + displacement,
                child: icon,
              ),
            ],
          );

        case 3:
          return Stack(
            children: [
              Positioned(
                top: centerTop,
                left: centerSide - displacement,
                child: icon,
              ),
              Positioned(
                top: centerTop,
                left: centerSide + displacement,
                child: icon,
              ),
              Positioned(
                top: centerTop - displacement,
                left: centerSide,
                child: icon,
              ),
            ],
          );
        default:
          return Container();
      }
    });
  }
}
