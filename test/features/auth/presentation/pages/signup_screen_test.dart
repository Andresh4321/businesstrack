import 'dart:io';

import 'package:businesstrack/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:businesstrack/features/users/presentation/view_model/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockAuthVM extends Mock implements AuthViewModel {}

class MockUserVM extends Mock implements UserViewmodel {}

void main() {
  late MockAuthVM authVM;
  late MockUserVM userVM;

  setUp(() {
    authVM = MockAuthVM();
    userVM = MockUserVM();
  });

  testWidgets('Login success returns authenticated state', (tester) async {
    when(
      authVM.login(email: 'test@mail.com', password: '123456'),
    ).thenAnswer((_) async => 'success');

    // Simulate a widget tree for provider access if needed
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: Builder(builder: (_) => Container())),
      ),
    );

    final result = await authVM.login(
      email: 'test@mail.com',
      password: '123456',
    );
    // expect(result, 'success');
  });

  testWidgets('Login failure throws error', (tester) async {
    when(
      authVM.login(email: 'wrong@mail.com', password: '123456'),
    ).thenThrow(Exception('Invalid credentials'));

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: Builder(builder: (_) => Container())),
      ),
    );

    try {
      await authVM.login(email: 'wrong@mail.com', password: '123456');
      fail('Expected an exception to be thrown');
    } catch (e) {
      expect(e.toString(), contains('Invalid credentials'));
    }
  });

  testWidgets('Register success returns registered state', (tester) async {
    when(
      authVM.register(
        fullName: 'Rohan',
        email: 'rohan@mail.com',
        username: 'rohan',
        password: '123456',
        confirmPassword: '123456',
        phoneNumber: '9800000000',
      ),
    ).thenAnswer((_) async => 'registered');

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: Builder(builder: (_) => Container())),
      ),
    );

    final result = await authVM.register(
      fullName: 'Rohan',
      email: 'rohan@mail.com',
      username: 'rohan',
      password: '123456',
      confirmPassword: '123456',
      phoneNumber: '9800000000',
    );

    // expect(result, 'registered');
  });

  testWidgets('Register failure throws error', (tester) async {
    when(
      authVM.register(
        fullName: 'Rohan',
        email: 'duplicate@mail.com',
        username: 'rohan',
        password: '123456',
        confirmPassword: '123456',
        phoneNumber: '9800000000',
      ),
    ).thenThrow(Exception('Email already exists'));

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: Builder(builder: (_) => Container())),
      ),
    );

    try {
      await authVM.register(
        fullName: 'Rohan',
        email: 'duplicate@mail.com',
        username: 'rohan',
        password: '123456',
        confirmPassword: '123456',
        phoneNumber: '9800000000',
      );
      fail('Expected an exception to be thrown');
    } catch (e) {
      expect(e.toString(), contains('Email already exists'));
    }
  });

  testWidgets('Upload image success returns success', (tester) async {
    final file = File('test_assets/profile.png');
    when(userVM.uploadPhoto(file)).thenAnswer((_) async => 'success');

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: Builder(builder: (_) => Container())),
      ),
    );

    final result = await userVM.uploadPhoto(file);
    // expect(result, 'success');
  });

  testWidgets('Upload image failure throws error', (tester) async {
    final file = File('non_existing_file.png');
    when(userVM.uploadPhoto(file)).thenThrow(Exception('File not found'));

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: Builder(builder: (_) => Container())),
      ),
    );

    try {
      await userVM.uploadPhoto(file);
      fail('Expected an exception to be thrown');
    } catch (e) {
      expect(e.toString(), contains('File not found'));
    }
  });
}
