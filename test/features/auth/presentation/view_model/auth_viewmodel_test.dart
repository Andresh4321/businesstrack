import 'package:businesstrack/features/auth/data/repositories/auth_repository.dart';
import 'package:businesstrack/features/auth/presentation/state/auth.state.dart';
import 'package:businesstrack/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_fakes.dart';

void main() {
  group('Auth ViewModel', () {
    test('initial state is AuthStatus.initial', () {
      final repo = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      expect(container.read(authViewModelProvider).status, AuthStatus.initial);
    });

    test('register success changes status to registered', () async {
      final repo = FakeAuthRepository()..registerResult = const Right(true);
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container
          .read(authViewModelProvider.notifier)
          .register(
            fullName: 'User',
            email: 'user@mail.com',
            username: 'user',
            password: '123456',
          );

      expect(
        container.read(authViewModelProvider).status,
        AuthStatus.registered,
      );
    });
  });
}
