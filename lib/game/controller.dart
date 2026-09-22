import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'engine.dart';

class PlayerInfo {
  const PlayerInfo(this.name, this.color);
  final String name;
  final Color color;
}

const kPlayers = [
  PlayerInfo('Red', Color(0xFFFF4D5E)),
  PlayerInfo('Green', Color(0xFF3DDC84)),
  PlayerInfo('Blue', Color(0xFF4D8DFF)),
  PlayerInfo('Yellow', Color(0xFFFFD447)),
  PlayerInfo('Purple', Color(0xFFC86BFF)),
  PlayerInfo('Cyan', Color(0xFF3DE0E0)),
  PlayerInfo('Orange', Color(0xFFFF9A3D)),
  PlayerInfo('White', Color(0xFFE8E8F0)),
];

const kBackground = Color(0xFF0B0C12);

class GameSettings {
  const GameSettings({
    required this.players,
    required this.cols,
    required this.rows,
  });
  final int players, cols, rows;
}

/// Drives the engine with animation timing. The board painter reads the
/// timestamps below against [clock] so nothing rebuilds per frame.
class GameController extends ChangeNotifier {
  GameController(this.settings)
    : engine = GameEngine(
        cols: settings.cols,
        rows: settings.rows,
        playerCount: settings.players,
      );

  final GameSettings settings;
  final GameEngine engine;
  final clock = Stopwatch()..start();
  Duration get now => clock.elapsed;

  bool busy = false;
  bool showWinner = false;
  int chain = 0;
  int moves = 0;

  /// Cells whose orbs are mid-flight to their neighbours.
  List<int> flying = const [];
  Duration flightStart = Duration.zero;
  Duration flightDuration = Duration.zero;

  final Map<int, Duration> poppedAt = {};
  int? rejectedCell;
  Duration rejectedAt = Duration.zero;

  int previousPlayer = 0;
  Duration turnChangedAt = Duration.zero;

  int? highlight;
  bool _disposed = false;

  PlayerInfo get currentPlayer => kPlayers[engine.current];

  void setHighlight(int? i) {
    if (i == highlight) return;
    highlight = i;
    notifyListeners();
  }

  Future<void> tap(int i) async {
    if (busy || engine.winner != null) return;
    if (!engine.place(i)) {
      rejectedCell = i;
      rejectedAt = now;
      HapticFeedback.vibrate();
      notifyListeners();
      return;
    }
    HapticFeedback.selectionClick();
    moves++;
    poppedAt[i] = now;
    busy = true;
    chain = 0;
    notifyListeners();

    while (engine.winner == null) {
      final boom = engine.unstable();
      if (boom.isEmpty) break;
      chain++;
      flying = boom;
      flightStart = now;
      // Long chains speed up so they never drag.
      flightDuration = Duration(milliseconds: max(90, 240 - chain * 12));
      HapticFeedback.lightImpact();
      notifyListeners();
      await Future.delayed(flightDuration);
      if (_disposed) return;
      engine.step();
      final t = now;
      for (final c in boom) {
        for (final n in engine.neighbors(c)) {
          poppedAt[n] = t;
        }
      }
      flying = const [];
      notifyListeners();
    }

    if (engine.winner != null) {
      HapticFeedback.heavyImpact();
      busy = false;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 700));
      if (_disposed) return;
      showWinner = true;
    } else {
      previousPlayer = engine.current;
      engine.endTurn();
      turnChangedAt = now;
      busy = false;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
