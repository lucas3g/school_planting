import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_planting/modules/home/presentation/home_page.dart';
import 'package:school_planting/modules/home/presentation/widgets/card_user_widget.dart';
import 'package:school_planting/modules/home/presentation/widgets/map_planting_widget.dart';

void main() {
  testWidgets('HomePage shows map and user card', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(find.byType(Stack), findsOneWidget);
    expect(find.byType(MapPlantingWidget), findsOneWidget);
    expect(find.byType(CardUserWidget), findsOneWidget);
  });
}
