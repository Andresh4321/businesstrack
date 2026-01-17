import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/auth/data/repositories/auth_repository.dart';
import 'package:businesstrack/features/auth/domain/entities/auth_entity.dart';
import 'package:businesstrack/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class LoginUsecaseParams extends Equatable {
  final String email;
  final String password;

  const LoginUsecaseParams({
    required this.email,
    required this.password
  });

  @override
  List<Object?> get props => [email, password];
}


//Provider for loginusecase
final LoginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LoginUsecase(authRepository: authRepository);
});
class LoginUsecase implements UsecasewithParams<AuthEntity, LoginUsecaseParams>{
  final IAuthRespository _authRepository;

  LoginUsecase({required IAuthRespository authRepository})
  : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call(LoginUsecaseParams params) {
  return _authRepository.Login(params.email, params.password);
  }
  
  @override
  Future<Either<Failure, AuthEntity>> createuser(LoginUsecaseParams params) {
    // TODO: implement createuser
    throw UnimplementedError();
  }
  
}