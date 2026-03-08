import 'package:businesstrack/features/auth/domain/usecases/register_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_fakes.dart';

void main() {
  group('Auth Usecases', () {
    test('RegisterUsecase registers user successfully', () async {
      final repo = FakeAuthRepository();
      final usecase = RegisterUsecase(authRepository: repo);

      final result = await usecase(
        const RegisterUsecaseParams(
          fullName: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
        ),
      );

      expect(result, const Right(true));
      expect(repo.lastRegistered?.fullName, 'John Doe');
    });
  });
}
