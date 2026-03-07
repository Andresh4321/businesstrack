import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/auth/data/repositories/auth_repository.dart';
import 'package:businesstrack/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordParams extends Equatable {
  final String email;

  const ForgotPasswordParams({required this.email});

  @override
  List<Object?> get props => [email];
}

final forgotPasswordUsecaseProvider = Provider<ForgotPasswordUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return ForgotPasswordUsecase(repository: repository);
});

class ForgotPasswordUsecase
    implements UsecasewithParams<bool, ForgotPasswordParams> {
  final IAuthRespository _repository;

  ForgotPasswordUsecase({required IAuthRespository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(ForgotPasswordParams params) {
    return _repository.forgotPassword(params.email);
  }
}
