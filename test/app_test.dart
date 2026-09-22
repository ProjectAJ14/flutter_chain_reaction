import 'package:flutter/material.dart';
import 'package:flutter_chain_reaction/main.dart';
import 'package:flutter_chain_reaction/ui/board.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('setup -> play -> tap places an orb and passes the turn', (
    tester,
  ) async {
    await tester.pumpWidget(const ChainReactionApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('PLAY'));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(BoardView), findsOneWidget);
    expect(find.text("Red's turn"), findsOneWidget);

    await tester.tap(
      find
          .descendant(
            of: find.byType(BoardView),
            matching: find.byType(CustomPaint),
          )
          .first,
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text("Green's turn"), findsOneWidget);
  });
}
