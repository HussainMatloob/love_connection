import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:love_connection/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Check if button is tappable', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp()); // Load main app

    expect(find.text('Press Me'), findsOneWidget); // Check if button exists

    await tester.tap(find.text('Press Me')); // Simulate tap
    await tester.pump(); // Rebuild UI after tap
  });
}
