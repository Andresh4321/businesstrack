import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/auth/data/repositories/auth_repository.dart';
import 'package:businesstrack/features/auth/domain/entities/auth_entity.dart';
import 'package:businesstrack/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final whoAmIUsecaseProvider = Provider<WhoAmIUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return WhoAmIUsecase(repository: repository);
});

class WhoAmIUsecase implements UsecasewithoutParams<AuthEntity> {
  final IAuthRespository _repository;

  WhoAmIUsecase({required IAuthRespository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, AuthEntity>> call() {
    return _repository.whoAmI();
  }
}
