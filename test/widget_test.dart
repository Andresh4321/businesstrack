import 'package:businesstrack/features/auth/presentation/pages/login_screen.dart';
import 'package:businesstrack/features/auth/presentation/pages/signup_screen.dart';
import 'package:businesstrack/features/auth/presentation/widgets/TextField.dart';
import 'package:businesstrack/features/auth/presentation/widgets/Textfield.dart';
import 'package:businesstrack/features/users/presentation/pages/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('LoginScreen shows email, password fields and login button', (tester) async {
  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(home: LoginScreen()),
    ),
  );
  await tester.pumpAndSettle();

  // Instead of counting TextField by type, check by label text
  expect(find.widgetWithText(Textfield, 'Email Address'), findsOneWidget);
  expect(find.widgetWithText(Textfield, 'Password'), findsOneWidget);

  // Check Sign In button exists
  // expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
});

testWidgets('SignupScreen shows all fields and Create Account button', (tester) async {
  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(home: SignupScreen()),
    ),
  );
  await tester.pumpAndSettle();

  // Check all fields by visible label text (works with custom Textfield)
  expect(find.text('Full Name'), findsOneWidget);
  expect(find.text('Phone Number'), findsOneWidget);
  expect(find.text('Email'), findsOneWidget);
  expect(find.text('Password'), findsOneWidget);
  expect(find.text('Confirm Password'), findsOneWidget);

  // Check Create Account button exists
  expect(find.widgetWithText(ElevatedButton, 'Create Account'), findsOneWidget);
});


  testWidgets('SettingsScreen shows profile image and settings tiles', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: SettingScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Dark Mode'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('LoginScreen shows error if fields are empty', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Fill all fields'), findsOneWidget);
  });

  testWidgets('SignupScreen validation shows error for unmatched passwords', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: SignupScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Enter password and wrong confirm password
    await tester.enterText(find.byType(TextFormField).at(3), '123456'); // password
    await tester.enterText(find.byType(TextFormField).last, '1234');    // confirm password

    await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}
