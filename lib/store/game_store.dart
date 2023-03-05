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
      color: Colors.red,
    ),
    Player(
      name: 'Player 2',
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

  @observable
  int winnerPlayerIndex = -1;

  @computed
  bool get hasWinner => winnerPlayerIndex != -1;

  @computed
  Player get winner => players[winnerPlayerIndex];

  int boardSize = 0;

  @observable
  ObservableList<GameTile> tiles = ObservableList<GameTile>();

  @action
  void init(int boardSize) {
    this.boardSize = boardSize;
    tiles = ObservableList.of(
      List.generate(
        boardSize * boardSize,
        (index) => GameTile(
          index: index,
          boardSize: boardSize,
          value: 0,
          playerIndex: -1,
        ),
      ),
    );
  }

  @action
  void reset() {
    tiles = ObservableList.of(
      List.generate(
        boardSize * boardSize,
        (index) => GameTile(
          index: index,
          boardSize: boardSize,
          value: 0,
          playerIndex: -1,
        ),
      ),
    );
    winnerPlayerIndex = -1;
    currentPlayerIndex = 0;
  }

  @action
  void setWinner(int playerIndex) {
    winnerPlayerIndex = playerIndex;
  }

  @action
  Future<void> playNeighbours(int tileIndex) async {
    final tile = tiles[tileIndex];
    for (var neighborIndex in tile.neighbors) {
      await play(neighborIndex, changeTurn: false, autoPlayed: true);
    }
  }

  @action
  Future<void> play(
    int tileIndex, {
    bool changeTurn = true,
    bool autoPlayed = false,
  }) async {
    logger.d('PLAY: $tileIndex${autoPlayed ? ' (auto)' : ''}'
        '${changeTurn ? '' : ' (no change turn)'}');
    final tile = tiles[tileIndex];

    if (tile.playerIndex != -1 &&
        tile.playerIndex != currentPlayerIndex &&
        !autoPlayed) {
      return;
    }

    if (hasWinner) {
      return;
    }

    //Check if player has won
    List<int> playerScores = [];
    for (int i = 0; i < players.length; i++) {
      final playerTiles = tiles.where((tile) => tile.playerIndex == i);
      int playerScore = playerTiles.isEmpty ? 0 : playerTiles.length;
      playerScores.add(playerScore);
    }

    //Check if the other player has zero tiles and the current player has more than 0 tiles
    if (playerScores[currentPlayerIndex] > 0 &&
        playerScores.where((score) => score == 0).length ==
            players.length - 1) {
      setWinner(currentPlayerIndex);
      return;
    }

    //Corner Tiles
    if (tile.onCorner) {
      if (tile.isEmpty) {
        tile.update(value: 1, playerIndex: currentPlayerIndex);
      } else {
        tile.update(value: 0, playerIndex: -1);
        await playNeighbours(tileIndex);
      }
    } else if (tile.onEdge) {
      if (tile.isEmpty) {
        tile.update(value: 1, playerIndex: currentPlayerIndex);
      } else if (tile.isLevel1) {
        tile.update(value: 2, playerIndex: currentPlayerIndex);
      } else {
        tile.update(value: 0, playerIndex: -1);
        await playNeighbours(tileIndex);
      }
    } else {
      if (tile.isEmpty) {
        tile.update(value: 1, playerIndex: currentPlayerIndex);
      } else if (tile.isLevel1) {
        tile.update(value: 2, playerIndex: currentPlayerIndex);
      } else if (tile.isLevel2) {
        tile.update(value: 3, playerIndex: currentPlayerIndex);
      } else {
        tile.update(value: 0, playerIndex: -1);
        await playNeighbours(tileIndex);
      }
    }

    if (changeTurn) {
      nextTurn();
    }
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
