// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_tile.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GameTile on _GameTile, Store {
  Computed<bool>? _$onCornerComputed;

  @override
  bool get onCorner => (_$onCornerComputed ??=
          Computed<bool>(() => super.onCorner, name: '_GameTile.onCorner'))
      .value;
  Computed<bool>? _$onEdgeComputed;

  @override
  bool get onEdge => (_$onEdgeComputed ??=
          Computed<bool>(() => super.onEdge, name: '_GameTile.onEdge'))
      .value;
  Computed<bool>? _$isEmptyComputed;

  @override
  bool get isEmpty => (_$isEmptyComputed ??=
          Computed<bool>(() => super.isEmpty, name: '_GameTile.isEmpty'))
      .value;
  Computed<bool>? _$isLevel1Computed;

  @override
  bool get isLevel1 => (_$isLevel1Computed ??=
          Computed<bool>(() => super.isLevel1, name: '_GameTile.isLevel1'))
      .value;
  Computed<bool>? _$isLevel2Computed;

  @override
  bool get isLevel2 => (_$isLevel2Computed ??=
          Computed<bool>(() => super.isLevel2, name: '_GameTile.isLevel2'))
      .value;
  Computed<bool>? _$isLevel3Computed;

  @override
  bool get isLevel3 => (_$isLevel3Computed ??=
          Computed<bool>(() => super.isLevel3, name: '_GameTile.isLevel3'))
      .value;
  Computed<List<int>>? _$neighborsComputed;

  @override
  List<int> get neighbors =>
      (_$neighborsComputed ??= Computed<List<int>>(() => super.neighbors,
              name: '_GameTile.neighbors'))
          .value;

  late final _$valueAtom = Atom(name: '_GameTile.value', context: context);

  @override
  int get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  late final _$playerIndexAtom =
      Atom(name: '_GameTile.playerIndex', context: context);

  @override
  int get playerIndex {
    _$playerIndexAtom.reportRead();
    return super.playerIndex;
  }

  @override
  set playerIndex(int value) {
    _$playerIndexAtom.reportWrite(value, super.playerIndex, () {
      super.playerIndex = value;
    });
  }

  late final _$isBlastedAtom =
      Atom(name: '_GameTile.isBlasted', context: context);

  @override
  bool get isBlasted {
    _$isBlastedAtom.reportRead();
    return super.isBlasted;
  }

  @override
  set isBlasted(bool value) {
    _$isBlastedAtom.reportWrite(value, super.isBlasted, () {
      super.isBlasted = value;
    });
  }

  late final _$blastPlayerIndexAtom =
      Atom(name: '_GameTile.blastPlayerIndex', context: context);

  @override
  int get blastPlayerIndex {
    _$blastPlayerIndexAtom.reportRead();
    return super.blastPlayerIndex;
  }

  @override
  set blastPlayerIndex(int value) {
    _$blastPlayerIndexAtom.reportWrite(value, super.blastPlayerIndex, () {
      super.blastPlayerIndex = value;
    });
  }

  late final _$positionAtom =
      Atom(name: '_GameTile.position', context: context);

  @override
  Position get position {
    _$positionAtom.reportRead();
    return super.position;
  }

  @override
  set position(Position value) {
    _$positionAtom.reportWrite(value, super.position, () {
      super.position = value;
    });
  }

  late final _$blastAsyncAction =
      AsyncAction('_GameTile.blast', context: context);

  @override
  Future<void> blast() {
    return _$blastAsyncAction.run(() => super.blast());
  }

  late final _$_GameTileActionController =
      ActionController(name: '_GameTile', context: context);

  @override
  void update({int? value, int? playerIndex, int blastPlayerIndex = -1}) {
    final _$actionInfo =
        _$_GameTileActionController.startAction(name: '_GameTile.update');
    try {
      return super.update(
          value: value,
          playerIndex: playerIndex,
          blastPlayerIndex: blastPlayerIndex);
    } finally {
      _$_GameTileActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value},
playerIndex: ${playerIndex},
isBlasted: ${isBlasted},
blastPlayerIndex: ${blastPlayerIndex},
position: ${position},
onCorner: ${onCorner},
onEdge: ${onEdge},
isEmpty: ${isEmpty},
isLevel1: ${isLevel1},
isLevel2: ${isLevel2},
isLevel3: ${isLevel3},
neighbors: ${neighbors}
    ''';
  }
}
