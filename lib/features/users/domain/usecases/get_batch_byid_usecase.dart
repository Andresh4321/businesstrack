import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/users/data/repositories/user_repository.dart';
import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:businesstrack/features/users/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetUserByIdParams extends Equatable {
  final String userId;

  const GetUserByIdParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final getUserByIdUsecaseProvider = Provider<GetUserByIdUsecase>((ref) {
  return GetUserByIdUsecase(userRepository: ref.read(UserRepositoryProvider));
});

class GetUserByIdUsecase
    implements UsecasewithParams<UserEntity, GetUserByIdParams> {
  final IUserRespository _userRepository;

  GetUserByIdUsecase({required IUserRespository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, UserEntity>> call(GetUserByIdParams params) {
    return _userRepository.getuserById(params.userId);
  }
}
