import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/auth/data/repositories/auth_repository.dart';
import 'package:businesstrack/features/auth/domain/entities/auth_entity.dart';
import 'package:businesstrack/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminLoginParams extends Equatable {
  final String email;
  final String password;

  const AdminLoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

final adminLoginUsecaseProvider = Provider<AdminLoginUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return AdminLoginUsecase(repository: repository);
});

class AdminLoginUsecase
    implements UsecasewithParams<AuthEntity, AdminLoginParams> {
  final IAuthRespository _repository;

  AdminLoginUsecase({required IAuthRespository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, AuthEntity>> call(AdminLoginParams params) {
    return _repository.adminLogin(params.email, params.password);
  }
}
