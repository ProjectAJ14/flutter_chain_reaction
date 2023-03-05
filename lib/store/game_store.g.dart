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
  Computed<bool>? _$hasWinnerComputed;

  @override
  bool get hasWinner => (_$hasWinnerComputed ??=
          Computed<bool>(() => super.hasWinner, name: '_GameStore.hasWinner'))
      .value;

  late final _$playersAtom = Atom(name: '_GameStore.players', context: context);

  @override
  List<Player> get players {
    _$playersAtom.reportRead();
    return super.players;
  }

  @override
  set players(List<Player> value) {
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
  void init(int boardSize) {
    final _$actionInfo =
        _$_GameStoreActionController.startAction(name: '_GameStore.init');
    try {
      return super.init(boardSize);
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
players: ${players},
currentPlayerIndex: ${currentPlayerIndex},
winnerPlayerIndex: ${winnerPlayerIndex},
tiles: ${tiles},
currentPlayerColor: ${currentPlayerColor},
hasWinner: ${hasWinner}
    ''';
  }
}
