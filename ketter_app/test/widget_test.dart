import 'package:flutter_test/flutter_test.dart';
import 'package:ketter_app/main.dart';

void main() {
  testWidgets('Dashboard smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KetterApp());

    // Verify that the dashboard shows "Ketter"
    expect(find.text('Ketter'), findsOneWidget);
    expect(find.text('Health Status'), findsNothing); // It's in a different widget/text now

    // Check for some dashboard elements
    expect(find.text('Heart Rate Trends'), findsOneWidget);
  });
}
