import 'package:flutter_test/flutter_test.dart';
import 'package:school_planting/app_widget.dart';

void main() {
  testWidgets('AppWidget matches golden file', (tester) async {
    await tester.pumpWidget(const AppWidget());
    await expectLater(
      find.byType(AppWidget),
      matchesGoldenFile('goldens/app_widget.png'),
    );
  });
}
