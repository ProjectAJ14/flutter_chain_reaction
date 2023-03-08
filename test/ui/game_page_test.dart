//GamePage
import 'package:flutter/material.dart';
import 'package:flutter_chain_reaction/ui/game_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('GamePage is rendered', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const GamePage(),
      ),
    );
    expect(find.byType(GamePage), findsOneWidget);
  });
}
