import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/users/data/repositories/repository_providers.dart';
import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:businesstrack/features/users/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetUserProfileParams extends Equatable {
  final String userId;

  const GetUserProfileParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final getUserProfileUsecaseProvider = Provider<GetUserProfileUsecase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return GetUserProfileUsecase(repository: repository);
});

class GetUserProfileUsecase
    implements UsecasewithParams<UserEntity, GetUserProfileParams> {
  final IUserRepository _repository;

  GetUserProfileUsecase({required IUserRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, UserEntity>> call(GetUserProfileParams params) {
    return _repository.getUserProfile(params.userId);
  }
}
