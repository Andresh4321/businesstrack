import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/users/data/repositories/repository_providers.dart';
import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:businesstrack/features/users/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateUserProfileParams extends Equatable {
  final UserEntity user;

  const UpdateUserProfileParams({required this.user});

  @override
  List<Object?> get props => [user];
}

final updateUserProfileUsecaseProvider = Provider<UpdateUserProfileUsecase>((
  ref,
) {
  final repository = ref.read(userRepositoryProvider);
  return UpdateUserProfileUsecase(repository: repository);
});

class UpdateUserProfileUsecase
    implements UsecasewithParams<UserEntity, UpdateUserProfileParams> {
  final IUserRepository _repository;

  UpdateUserProfileUsecase({required IUserRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, UserEntity>> call(UpdateUserProfileParams params) {
    return _repository.updateUserProfile(params.user);
  }
}
