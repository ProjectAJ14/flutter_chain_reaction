import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../model/game_tile.dart';
import '../../store/game_store.dart';

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
    return Observer(builder: (context) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Text(
                tile.toShow(),
                style: TextStyle(
                  color: Colors.white30,
                  fontSize: size * 0.4,
                ),
              ),
              Center(
                child: _buildTile(context),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTile(
    BuildContext context,
  ) {
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
  }
}
