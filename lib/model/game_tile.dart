import 'package:mobx/mobx.dart';

import '../services/index.dart';

part 'game_tile.g.dart';

class GameTile = _GameTile with _$GameTile;

abstract class _GameTile with Store {
  int index = 0;

  @observable
  int value = 0;

  @observable
  int playerIndex = -1;

  int boardSize = 0;

  @observable
  Position position = Position(x: 0, y: 0);

  _GameTile({
    required this.index,
    required this.boardSize,
    required this.value,
    required this.playerIndex,
  }) {
    position = Position(
      x: index ~/ boardSize,
      y: index % boardSize,
    );
  }

  @computed
  bool get onCorner =>
      position.x == 0 && position.y == 0 ||
      position.x == (boardSize - 1) && position.y == 0 ||
      position.x == (boardSize - 1) && position.y == (boardSize - 1) ||
      position.x == 0 && position.y == (boardSize - 1);

  @computed
  bool get onEdge =>
      (position.x == 0 && (position.y != 0 || position.y != (boardSize - 1))) ||
      (position.x == (boardSize - 1) &&
          (position.y != 0 || position.y != (boardSize - 1))) ||
      (position.y == 0 && (position.x != 0 || position.x != (boardSize - 1))) ||
      (position.y == (boardSize - 1) &&
          (position.x != 0 || position.x != (boardSize - 1)));

  @computed
  bool get isEmpty => value == 0;

  @computed
  bool get isLevel1 => value == 1;

  @computed
  bool get isLevel2 => value == 2;

  @computed
  bool get isLevel3 => value == 3;

  @computed
  List<int> get neighbors {
    final neighbors = <int>[];
    if (position.x > 0) {
      neighbors.add(index - boardSize);
    }
    if (position.x < (boardSize - 1)) {
      neighbors.add(index + boardSize);
    }
    if (position.y > 0) {
      neighbors.add(index - 1);
    }
    if (position.y < (boardSize - 1)) {
      neighbors.add(index + 1);
    }
    return neighbors;
  }

  @action
  void update({
    int? value,
    int? playerIndex,
  }) {
    final valueX = value ?? this.value;
    final playerIndexX = playerIndex ?? this.playerIndex;

    logger.d('UPDATE($index): value(${this.value}->$valueX)'
        ' playerIndex(${this.playerIndex}->$playerIndexX)');

    this.value = valueX;
    this.playerIndex = playerIndexX;
  }

  String toShow() {
    return '${onCorner ? 'C' : ''}${onEdge ? 'E' : ''}($position)=$value,$playerIndex,$neighbors';
  }
}

class Position {
  final int x;
  final int y;

  Position({
    required this.x,
    required this.y,
  });

  @override
  String toString() {
    return '$x, $y';
  }
}
