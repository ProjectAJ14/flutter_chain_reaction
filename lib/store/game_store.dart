import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../model/game_tile.dart';
import '../model/player.dart';
import '../services/index.dart';

part 'game_store.g.dart';

class GameStore = _GameStore with _$GameStore;

abstract class _GameStore with Store {
  @observable
  List<Player> players = [
    Player(
      name: 'Player 1',
      score: 0,
      color: Colors.red,
    ),
    Player(
      name: 'Player 2',
      score: 0,
      color: Colors.green,
    ),
  ];

  @computed
  Color get currentPlayerColor => players[currentPlayerIndex].color;

  Color byPlayerIndex(int playerIndex) {
    if (playerIndex == -1) {
      return Colors.transparent;
    }
    return players[playerIndex].color;
  }

  @observable
  int currentPlayerIndex = 0;

  int boardSize = 0;

  @observable
  List<GameTile> tiles = [];

  @action
  void init(int boardSize) {
    this.boardSize = boardSize;
    tiles = List.generate(
      boardSize * boardSize,
      (index) => GameTile(
        index: index,
        boardSize: boardSize,
        // value: 1,
        // playerIndex: index % 2 == 0 ? 0 : 1,
      ),
    );
  }

  @action
  Future<int> play(
    int tileIndex, {
    bool changeTurn = true,
    bool autoPlayed = false,
  }) async {
    logger.d('play: $tileIndex${autoPlayed ? ' (auto)' : ''}'
        '${changeTurn ? '' : ' (no change turn)'}');
    final tile = tiles[tileIndex];

    if (tile.playerIndex != -1 &&
        tile.playerIndex != currentPlayerIndex &&
        !autoPlayed) {
      return -1;
    }

    if (autoPlayed) {
      //Check if player has won
      final playerTiles = tiles
          .where(
              (t) => t.playerIndex == currentPlayerIndex || t.playerIndex == -1)
          .toList();
      if (playerTiles.length == boardSize * boardSize) {
        //Player has won
        return currentPlayerIndex;
      }
    }

    //Corner Tiles
    if (tile.onCorner) {
      if (tile.isEmpty) {
        tiles[tileIndex] =
            tile.copyWith(value: 1, playerIndex: currentPlayerIndex);
      } else {
        tiles[tileIndex] = tile.copyWith(value: 0, playerIndex: -1);
        //Play on neighbors
        for (var neighborIndex in tile.neighbors) {
          int result = await play(
            neighborIndex,
            changeTurn: false,
            autoPlayed: true,
          );
          if (result != -1) {
            return result;
          }
        }
      }
    } else if (tile.onEdge) {
      if (tile.isEmpty) {
        tiles[tileIndex] =
            tile.copyWith(value: 1, playerIndex: currentPlayerIndex);
      } else if (tile.isLevel1) {
        tiles[tileIndex] =
            tile.copyWith(value: 2, playerIndex: currentPlayerIndex);
      } else {
        tiles[tileIndex] = tile.copyWith(value: 0, playerIndex: -1);
        //Play on neighbors
        for (var neighborIndex in tile.neighbors) {
          int result = await play(
            neighborIndex,
            changeTurn: false,
            autoPlayed: true,
          );
          if (result != -1) {
            return result;
          }
        }
      }
    } else {
      if (tile.isEmpty) {
        tiles[tileIndex] =
            tile.copyWith(value: 1, playerIndex: currentPlayerIndex);
      } else if (tile.isLevel1) {
        tiles[tileIndex] =
            tile.copyWith(value: 2, playerIndex: currentPlayerIndex);
      } else if (tile.isLevel2) {
        tiles[tileIndex] =
            tile.copyWith(value: 3, playerIndex: currentPlayerIndex);
      } else {
        tiles[tileIndex] = tile.copyWith(value: 0, playerIndex: -1);
        //Play on neighbors
        for (var neighborIndex in tile.neighbors) {
          int result = await play(
            neighborIndex,
            changeTurn: false,
            autoPlayed: true,
          );
          if (result != -1) {
            return result;
          }
        }
      }
    }

    if (changeTurn) {
      nextTurn();
    }
    return -1;
  }

  @action
  void nextTurn() {
    int nextPlayerIndex = currentPlayerIndex + 1;
    if (nextPlayerIndex >= players.length) {
      nextPlayerIndex = 0;
    }
    logger.d('nextTurn($currentPlayerIndex)->$nextPlayerIndex ');
    currentPlayerIndex = nextPlayerIndex;
  }
}
