import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../model/game_tile.dart';
import '../model/player.dart';
import '../services/index.dart';

part 'game_store.g.dart';

enum GameStatus { init, play }

const List<MaterialColor> primaries = <MaterialColor>[
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.teal,
  Colors.cyan,
];

class GameStore = _GameStore with _$GameStore;

abstract class _GameStore with Store {
  @observable
  GameStatus status = GameStatus.init;

  @observable
  ObservableList<Player> players = ObservableList<Player>();

  @computed
  Color get currentPlayerColor => players[currentPlayerIndex].color;

  @computed
  bool get allPlayersHavePlayed =>
      players.where((player) => !player.hasPlayed).isEmpty;

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

  @observable
  int boardSize = 10;

  @observable
  int playerCount = 2;

  @observable
  ObservableList<GameTile> tiles = ObservableList<GameTile>();

  @action
  void init() {
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
    players = ObservableList.of(
      List.generate(
        playerCount,
        (index) => Player(
          name: 'Player ${index + 1}',
          color: primaries[index],
        ),
      ),
    );
    status = GameStatus.play;
  }

  @action
  void setBoardSize(int value) {
    logger.d('SET BOARD SIZE: $value');
    boardSize = value;
  }

  @action
  void setPlayerCount(int value) {
    logger.d('SET PLAYER COUNT: $value');
    playerCount = value;
  }

  @action
  void reset() {
    //Reset players
    players.clear();
    //Reset tiles
    tiles.clear();
    //Reset winner
    winnerPlayerIndex = -1;
    //Reset current player
    currentPlayerIndex = 0;
    //Reset status
    status = GameStatus.init;
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
    await Future.delayed(const Duration(milliseconds: 10));
    final tile = tiles[tileIndex];
    if (tile.playerIndex != -1 &&
        tile.playerIndex != currentPlayerIndex &&
        !autoPlayed) {
      return;
    }
    //Check if current player has played
    final currentPlayer = players[currentPlayerIndex];
    if (!currentPlayer.hasPlayed) {
      currentPlayer.hasPlayed = true;
    }

    checkWinner();

    //Corner Tiles
    if (tile.onCorner) {
      if (tile.isEmpty) {
        tile.update(value: 1, playerIndex: currentPlayerIndex);
      } else {
        tile.update(
          value: 0,
          playerIndex: -1,
          blastPlayerIndex: currentPlayerIndex,
        );
        await playNeighbours(tileIndex);
      }
    } else if (tile.onEdge) {
      if (tile.isEmpty) {
        tile.update(value: 1, playerIndex: currentPlayerIndex);
      } else if (tile.isLevel1) {
        tile.update(value: 2, playerIndex: currentPlayerIndex);
      } else {
        tile.update(
          value: 0,
          playerIndex: -1,
          blastPlayerIndex: currentPlayerIndex,
        );
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
        tile.update(
          value: 0,
          playerIndex: -1,
          blastPlayerIndex: currentPlayerIndex,
        );
        await playNeighbours(tileIndex);
      }
    }
    markAsLost();

    if (changeTurn) {
      nextTurn();
    }
  }

  @action
  void markAsLost() {
    if (allPlayersHavePlayed) {
      //Mark the player who has played and their score is zero as not lost
      for (int i = 0; i < players.length; i++) {
        final player = players[i];
        if (player.hasLost) {
          continue;
        }
        final playerTiles = tiles.where((tile) => tile.playerIndex == i);
        int playerScore = playerTiles.isEmpty ? 0 : playerTiles.length;
        if (playerScore == 0) {
          player.hasLost = true;
        }
      }
    }
  }

  @action
  bool checkWinner() {
    if (allPlayersHavePlayed) {
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
        return true;
      }
    }
    return false;
  }

  @action
  void nextTurn() {
    if (checkWinner()) {
      return;
    }
    while (true) {
      currentPlayerIndex++;
      if (currentPlayerIndex >= players.length) {
        currentPlayerIndex = 0;
      }
      if (!players[currentPlayerIndex].hasLost) {
        break;
      }
    }
  }
}
