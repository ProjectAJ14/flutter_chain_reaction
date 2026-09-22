/// Pure game rules. No Flutter, no timing — the controller drives animation.
class GameEngine {
  GameEngine({
    required this.cols,
    required this.rows,
    required this.playerCount,
  }) : _count = List.filled(cols * rows, 0),
       _owner = List.filled(cols * rows, -1),
       _moved = List.filled(playerCount, false),
       _neighbors = List.generate(cols * rows, (i) {
         final x = i % cols, y = i ~/ cols;
         return [
           if (y > 0) i - cols,
           if (x < cols - 1) i + 1,
           if (y < rows - 1) i + cols,
           if (x > 0) i - 1,
         ];
       });

  final int cols, rows, playerCount;
  final List<int> _count, _owner;
  final List<bool> _moved;
  final List<List<int>> _neighbors;

  int current = 0;
  int? winner;

  int get length => _count.length;
  int count(int i) => _count[i];
  int owner(int i) => _owner[i];
  List<int> neighbors(int i) => _neighbors[i];
  int capacity(int i) => _neighbors[i].length;

  /// One more orb and this cell blows.
  bool isCritical(int i) => _count[i] > 0 && _count[i] >= capacity(i) - 1;

  int orbsOf(int p) {
    var sum = 0;
    for (var i = 0; i < length; i++) {
      if (_owner[i] == p) sum += _count[i];
    }
    return sum;
  }

  /// A player is out once they've moved and own nothing.
  bool isAlive(int p) => !_moved[p] || orbsOf(p) > 0;

  bool canPlace(int i) =>
      winner == null && (_owner[i] == -1 || _owner[i] == current);

  bool place(int i) {
    if (!canPlace(i)) return false;
    _moved[current] = true;
    _owner[i] = current;
    _count[i]++;
    return true;
  }

  List<int> unstable() => [
    for (var i = 0; i < length; i++)
      if (_count[i] >= capacity(i)) i,
  ];

  /// Explodes every unstable cell at once (one wave). Returns the cells that
  /// exploded; empty means the board is stable or the game is over.
  List<int> step() {
    if (winner != null) return const [];
    final boom = unstable();
    for (final i in boom) {
      final p = _owner[i];
      _count[i] -= capacity(i);
      if (_count[i] == 0) _owner[i] = -1;
      for (final n in _neighbors[i]) {
        _owner[n] = p;
        _count[n]++;
      }
    }
    final alive = [
      for (var p = 0; p < playerCount; p++)
        if (isAlive(p)) p,
    ];
    if (alive.length == 1) winner = alive.single;
    return boom;
  }

  void endTurn() {
    do {
      current = (current + 1) % playerCount;
    } while (!isAlive(current));
  }
}
