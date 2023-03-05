// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GameStore on _GameStore, Store {
  Computed<Color>? _$currentPlayerColorComputed;

  @override
  Color get currentPlayerColor => (_$currentPlayerColorComputed ??=
          Computed<Color>(() => super.currentPlayerColor,
              name: '_GameStore.currentPlayerColor'))
      .value;
  Computed<bool>? _$allPlayersHavePlayedComputed;

  @override
  bool get allPlayersHavePlayed => (_$allPlayersHavePlayedComputed ??=
          Computed<bool>(() => super.allPlayersHavePlayed,
              name: '_GameStore.allPlayersHavePlayed'))
      .value;
  Computed<bool>? _$hasWinnerComputed;

  @override
  bool get hasWinner => (_$hasWinnerComputed ??=
          Computed<bool>(() => super.hasWinner, name: '_GameStore.hasWinner'))
      .value;
  Computed<Player>? _$winnerComputed;

  @override
  Player get winner => (_$winnerComputed ??=
          Computed<Player>(() => super.winner, name: '_GameStore.winner'))
      .value;

  late final _$statusAtom = Atom(name: '_GameStore.status', context: context);

  @override
  GameStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(GameStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$playersAtom = Atom(name: '_GameStore.players', context: context);

  @override
  ObservableList<Player> get players {
    _$playersAtom.reportRead();
    return super.players;
  }

  @override
  set players(ObservableList<Player> value) {
    _$playersAtom.reportWrite(value, super.players, () {
      super.players = value;
    });
  }

  late final _$currentPlayerIndexAtom =
      Atom(name: '_GameStore.currentPlayerIndex', context: context);

  @override
  int get currentPlayerIndex {
    _$currentPlayerIndexAtom.reportRead();
    return super.currentPlayerIndex;
  }

  @override
  set currentPlayerIndex(int value) {
    _$currentPlayerIndexAtom.reportWrite(value, super.currentPlayerIndex, () {
      super.currentPlayerIndex = value;
    });
  }

  late final _$winnerPlayerIndexAtom =
      Atom(name: '_GameStore.winnerPlayerIndex', context: context);

  @override
  int get winnerPlayerIndex {
    _$winnerPlayerIndexAtom.reportRead();
    return super.winnerPlayerIndex;
  }

  @override
  set winnerPlayerIndex(int value) {
    _$winnerPlayerIndexAtom.reportWrite(value, super.winnerPlayerIndex, () {
      super.winnerPlayerIndex = value;
    });
  }

  late final _$boardSizeAtom =
      Atom(name: '_GameStore.boardSize', context: context);

  @override
  int get boardSize {
    _$boardSizeAtom.reportRead();
    return super.boardSize;
  }

  @override
  set boardSize(int value) {
    _$boardSizeAtom.reportWrite(value, super.boardSize, () {
      super.boardSize = value;
    });
  }

  late final _$playerCountAtom =
      Atom(name: '_GameStore.playerCount', context: context);

  @override
  int get playerCount {
    _$playerCountAtom.reportRead();
    return super.playerCount;
  }

  @override
  set playerCount(int value) {
    _$playerCountAtom.reportWrite(value, super.playerCount, () {
      super.playerCount = value;
    });
  }

  late final _$tilesAtom = Atom(name: '_GameStore.tiles', context: context);

  @override
  ObservableList<GameTile> get tiles {
    _$tilesAtom.reportRead();
    return super.tiles;
  }

  @override
  set tiles(ObservableList<GameTile> value) {
    _$tilesAtom.reportWrite(value, super.tiles, () {
      super.tiles = value;
    });
  }

  late final _$playNeighboursAsyncAction =
      AsyncAction('_GameStore.playNeighbours', context: context);

  @override
  Future<void> playNeighbours(int tileIndex) {
    return _$playNeighboursAsyncAction
        .run(() => super.playNeighbours(tileIndex));
  }

  late final _$playAsyncAction =
      AsyncAction('_GameStore.play', context: context);

  @override
  Future<void> play(int tileIndex,
      {bool changeTurn = true, bool autoPlayed = false}) {
    return _$playAsyncAction.run(() =>
        super.play(tileIndex, changeTurn: changeTurn, autoPlayed: autoPlayed));
  }

  late final _$_GameStoreActionController =
      ActionController(name: '_GameStore', context: context);

  @override
  void init() {
    final _$actionInfo =
        _$_GameStoreActionController.startAction(name: '_GameStore.init');
    try {
      return super.init();
    } finally {
      _$_GameStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBoardSize(int value) {
    final _$actionInfo = _$_GameStoreActionController.startAction(
        name: '_GameStore.setBoardSize');
    try {
      return super.setBoardSize(value);
    } finally {
      _$_GameStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPlayerCount(int value) {
    final _$actionInfo = _$_GameStoreActionController.startAction(
        name: '_GameStore.setPlayerCount');
    try {
      return super.setPlayerCount(value);
    } finally {
      _$_GameStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo =
        _$_GameStoreActionController.startAction(name: '_GameStore.reset');
    try {
      return super.reset();
    } finally {
      _$_GameStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setWinner(int playerIndex) {
    final _$actionInfo =
        _$_GameStoreActionController.startAction(name: '_GameStore.setWinner');
    try {
      return super.setWinner(playerIndex);
    } finally {
      _$_GameStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void markAsLost() {
    final _$actionInfo =
        _$_GameStoreActionController.startAction(name: '_GameStore.markAsLost');
    try {
      return super.markAsLost();
    } finally {
      _$_GameStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool checkWinner() {
    final _$actionInfo = _$_GameStoreActionController.startAction(
        name: '_GameStore.checkWinner');
    try {
      return super.checkWinner();
    } finally {
      _$_GameStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextTurn() {
    final _$actionInfo =
        _$_GameStoreActionController.startAction(name: '_GameStore.nextTurn');
    try {
      return super.nextTurn();
    } finally {
      _$_GameStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status},
players: ${players},
currentPlayerIndex: ${currentPlayerIndex},
winnerPlayerIndex: ${winnerPlayerIndex},
boardSize: ${boardSize},
playerCount: ${playerCount},
tiles: ${tiles},
currentPlayerColor: ${currentPlayerColor},
allPlayersHavePlayed: ${allPlayersHavePlayed},
hasWinner: ${hasWinner},
winner: ${winner}
    ''';
  }
}
