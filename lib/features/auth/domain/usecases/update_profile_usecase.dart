import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/auth/data/repositories/auth_repository.dart';
import 'package:businesstrack/features/auth/domain/entities/auth_entity.dart';
import 'package:businesstrack/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateProfileParams extends Equatable {
  final AuthEntity entity;

  const UpdateProfileParams({required this.entity});

  @override
  List<Object?> get props => [entity];
}

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return UpdateProfileUsecase(repository: repository);
});

class UpdateProfileUsecase
    implements UsecasewithParams<AuthEntity, UpdateProfileParams> {
  final IAuthRespository _repository;

  UpdateProfileUsecase({required IAuthRespository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, AuthEntity>> call(UpdateProfileParams params) {
    return _repository.updateProfile(params.entity);
  }
}
