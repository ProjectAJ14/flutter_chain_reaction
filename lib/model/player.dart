import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'player.g.dart';

class Player = _Player with _$Player;

abstract class _Player with Store {
  String name;
  Color color;

  @observable
  bool hasLost = false;

  @observable
  bool hasPlayed = false;

  @observable
  int score = 0;

  @action
  void incrementScore({int? value}) {
    score += value ?? 1;
  }

  @action
  void resetScore() {
    score = 0;
  }

  @action
  void decrementScore({int? value}) {
    score -= value ?? 1;
  }

  _Player({
    required this.name,
    required this.color,
  });
}
