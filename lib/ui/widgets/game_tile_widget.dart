import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.black,
        child: Center(
          child: GameIconWidget(
            size: size,
            tile: tile,
            parentSize: parentSize,
          ),
        ),
      ).animate(delay: const Duration(milliseconds: 100)).scale(),
    );
  }
}
