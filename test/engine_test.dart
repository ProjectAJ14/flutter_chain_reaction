import 'dart:math';

import 'package:flutter_chain_reaction/game/engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('corner explodes at 2 and spreads to both neighbours', () {
    final e = GameEngine(cols: 3, rows: 3, playerCount: 2);
    e.place(0);
    e.endTurn();
    e.place(8);
    e.endTurn();
    e.place(0);
    expect(e.step(), [0]);
    expect(e.count(0), 0);
    expect(e.owner(0), -1);
    expect([e.count(1), e.owner(1), e.count(3), e.owner(3)], [1, 0, 1, 0]);
    expect(e.step(), isEmpty);
  });

  test('cannot place on an opponent cell', () {
    final e = GameEngine(cols: 3, rows: 3, playerCount: 2);
    e.place(4);
    e.endTurn();
    expect(e.place(4), isFalse);
    expect(e.place(5), isTrue);
  });

  test('capturing the last opponent orb wins', () {
    final e = GameEngine(cols: 3, rows: 3, playerCount: 2);
    e.place(0);
    e.endTurn();
    e.place(1);
    e.endTurn();
    e.place(0);
    while (e.step().isNotEmpty) {}
    expect(e.winner, 0);
  });

  test('random games always terminate with a winner', () {
    final rng = Random(42);
    for (var g = 0; g < 300; g++) {
      final e = GameEngine(
        cols: 5 + rng.nextInt(4),
        rows: 8 + rng.nextInt(5),
        playerCount: 2 + rng.nextInt(7),
      );
      var moves = 0;
      while (e.winner == null) {
        final legal = [
          for (var i = 0; i < e.length; i++)
            if (e.canPlace(i)) i,
        ];
        expect(e.place(legal[rng.nextInt(legal.length)]), isTrue);
        var waves = 0;
        while (e.step().isNotEmpty) {
          expect(++waves, lessThan(5000));
        }
        if (e.winner == null) e.endTurn();
        expect(++moves, lessThan(20000));
      }
      expect(e.isAlive(e.winner!), isTrue);
    }
  });
}
