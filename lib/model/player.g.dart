// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Player on _Player, Store {
  late final _$hasLostAtom = Atom(name: '_Player.hasLost', context: context);

  @override
  bool get hasLost {
    _$hasLostAtom.reportRead();
    return super.hasLost;
  }

  @override
  set hasLost(bool value) {
    _$hasLostAtom.reportWrite(value, super.hasLost, () {
      super.hasLost = value;
    });
  }

  late final _$hasPlayedAtom =
      Atom(name: '_Player.hasPlayed', context: context);

  @override
  bool get hasPlayed {
    _$hasPlayedAtom.reportRead();
    return super.hasPlayed;
  }

  @override
  set hasPlayed(bool value) {
    _$hasPlayedAtom.reportWrite(value, super.hasPlayed, () {
      super.hasPlayed = value;
    });
  }

  @override
  String toString() {
    return '''
hasLost: ${hasLost},
hasPlayed: ${hasPlayed}
    ''';
  }
}
