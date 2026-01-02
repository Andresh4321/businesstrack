import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/auth/data/repositories/auth_repository.dart';
import 'package:businesstrack/features/auth/domain/entities/auth_entity.dart';
import 'package:businesstrack/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterUsecaseParams extends Equatable {
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String password;

  const RegisterUsecaseParams({
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [
        fullName,
        email,
        phoneNumber,
        password,
      ];
}

final registerUseCaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(AuthRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase
    implements UsecasewithParams<bool, RegisterUsecaseParams> {
  final IAuthRespository _authRepository;

  RegisterUsecase({required IAuthRespository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      password: params.password,
    );

    return _authRepository.register(entity);
  }
  
  @override
  Future<Either<Failure, bool>> createuser(RegisterUsecaseParams params) {
    // TODO: implement createuser
    throw UnimplementedError();
  }
}
