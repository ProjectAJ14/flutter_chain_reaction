import '../services/index.dart';

class GameTile {
  final int index;
  final int value;
  final int playerIndex;
  final int boardSize;
  late Position position;

  GameTile({
    required this.index,
    required this.boardSize,
    this.value = 0,
    this.playerIndex = -1,
  }) {
    position = Position(
      x: index ~/ boardSize,
      y: index % boardSize,
    );
  }

  bool get onCorner =>
      position.x == 0 && position.y == 0 ||
      position.x == (boardSize - 1) && position.y == 0 ||
      position.x == (boardSize - 1) && position.y == (boardSize - 1) ||
      position.x == 0 && position.y == (boardSize - 1);

  bool get onEdge =>
      (position.x == 0 && (position.y != 0 || position.y != (boardSize - 1))) ||
      (position.x == (boardSize - 1) &&
          (position.y != 0 || position.y != (boardSize - 1))) ||
      (position.y == 0 && (position.x != 0 || position.x != (boardSize - 1))) ||
      (position.y == (boardSize - 1) &&
          (position.x != 0 || position.x != (boardSize - 1)));

  bool get isEmpty => value == 0;

  bool get isLevel1 => value == 1;

  bool get isLevel2 => value == 2;

  bool get isLevel3 => value == 3;

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

  copyWith({
    int? value,
    int? playerIndex,
  }) {
    final valueX = value ?? this.value;
    final playerIndexX = playerIndex ?? this.playerIndex;

    logger.d('copyWith($index): value(${this.value}->$valueX)'
        ' playerIndex(${this.playerIndex}->$playerIndexX)');

    return GameTile(
      index: index,
      boardSize: boardSize,
      value: valueX,
      playerIndex: playerIndexX,
    );
  }

  @override
  String toString() {
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
