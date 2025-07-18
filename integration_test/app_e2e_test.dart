import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:school_planting/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full app startup', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Green Map'), findsOneWidget);
  });
}
