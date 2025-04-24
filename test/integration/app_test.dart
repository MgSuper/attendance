import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cicoattendance/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Sign in flow test', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    final emailField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);
    final signInButton = find.text('Sign In');

    await tester.enterText(emailField, 'dummy1cr@gmail.com');
    await tester.enterText(passwordField, 'Dummy1');
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);
  });
}
