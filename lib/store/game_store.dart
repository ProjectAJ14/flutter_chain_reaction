import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../model/board_size.dart';
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
];

class GameStore = _GameStore with _$GameStore;

abstract class _GameStore with Store {
  @observable
  GameStatus status = GameStatus.init;

  @observable
  ObservableList<Player> players = ObservableList<Player>();

  @computed
  Color get currentPlayerColor => players[currentPlayerIndex].color;

  bool? _allPlayersHavePlayed;

  @computed
  bool get allPlayersHavePlayed =>
      _allPlayersHavePlayed ??
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
  BoardSize boardSize = const BoardSize(6, 9);

  @observable
  int playerCount = 2;

  @observable
  ObservableList<GameTile> tiles = ObservableList<GameTile>();

  @action
  void init() {
    tiles = ObservableList.of(
      List.generate(
        boardSize.width * boardSize.height,
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
  void setBoardSize(BoardSize value) {
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
    //Reset all players have played
    _allPlayersHavePlayed = null;
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
    DateTime now = DateTime.now();
    logger.d('PLAY: $tileIndex${autoPlayed ? ' (auto)' : ''}'
        '${changeTurn ? '' : ' (no change turn)'}');

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

    if (tile.isEmpty) {
      currentPlayer.incrementScore();
      tile.update(value: 1, playerIndex: currentPlayerIndex);
      if (changeTurn) {
        nextTurn();
        logger.d(
            'PLAY DURATION: ${DateTime.now().difference(now).inMilliseconds}ms');
        return;
      }
    } else {
      checkWinner();
      //Corner Tiles
      if (tile.onCorner) {
        if (tile.playerIndex == currentPlayerIndex) {
          currentPlayer.decrementScore();
        } else {
          players[tile.playerIndex].decrementScore();
        }
        tile.update(
          value: 0,
          playerIndex: -1,
          blastPlayerIndex: currentPlayerIndex,
        );
        await playNeighbours(tileIndex);
      } else if (tile.onEdge) {
        if (tile.isLevel1) {
          if (tile.playerIndex == currentPlayerIndex) {
            currentPlayer.incrementScore();
          } else {
            currentPlayer.incrementScore(value: 2);
            players[tile.playerIndex].decrementScore();
          }
          tile.update(value: 2, playerIndex: currentPlayerIndex);
        } else {
          if (tile.playerIndex == currentPlayerIndex) {
            currentPlayer.decrementScore(value: 2);
          } else {
            players[tile.playerIndex].decrementScore(value: 2);
          }
          tile.update(
            value: 0,
            playerIndex: -1,
            blastPlayerIndex: currentPlayerIndex,
          );
          await playNeighbours(tileIndex);
        }
      } else {
        if (tile.isLevel1) {
          if (tile.playerIndex == currentPlayerIndex) {
            currentPlayer.incrementScore();
          } else {
            currentPlayer.incrementScore(value: 2);
            players[tile.playerIndex].decrementScore(value: 1);
          }
          tile.update(value: 2, playerIndex: currentPlayerIndex);
        } else if (tile.isLevel2) {
          if (tile.playerIndex == currentPlayerIndex) {
            currentPlayer.incrementScore();
          } else {
            currentPlayer.incrementScore(value: 3);
            players[tile.playerIndex].decrementScore(value: 2);
          }
          tile.update(value: 3, playerIndex: currentPlayerIndex);
        } else {
          if (tile.playerIndex == currentPlayerIndex) {
            currentPlayer.decrementScore(value: 3);
          } else {
            players[tile.playerIndex].decrementScore(value: 3);
          }
          tile.update(
            value: 0,
            playerIndex: -1,
            blastPlayerIndex: currentPlayerIndex,
          );
          await playNeighbours(tileIndex);
        }
      }
    }

    if (autoPlayed) {
      await Future.delayed(const Duration(milliseconds: 5));
    }

    if (changeTurn) {
      if (checkWinner()) {
        return;
      }
      nextTurn();
      logger.d(
          'PLAY DURATION: ${DateTime.now().difference(now).inMilliseconds}ms');
    }
  }

  @action
  bool checkWinner() {
    if (allPlayersHavePlayed) {
      _allPlayersHavePlayed = true;

      List<int> playerScores = [];
      //Mark the player who has played and their score is zero as not lost
      for (int i = 0; i < players.length; i++) {
        final player = players[i];
        playerScores.add(player.score);
        if (player.hasLost || i == currentPlayerIndex) {
          continue;
        } else if (player.hasPlayed && player.score == 0) {
          player.hasLost = true;
        }
      }
      //Check if the other player has zero tiles and the current player has more than 0 tiles
      if (playerScores[currentPlayerIndex] > 0 &&
          playerScores.where((score) => score == 0).length ==
              playerScores.length - 1) {
        setWinner(currentPlayerIndex);
        return true;
      }
    }
    return false;
  }

  @action
  void nextTurn() {
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
