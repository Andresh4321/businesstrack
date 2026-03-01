import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/users/data/repositories/user_repository.dart';
import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:businesstrack/features/users/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAlluserUsecaseProvider = Provider<GetAllUserUsecase>((ref) {
  return GetAllUserUsecase(userRepository: ref.read(UserRepositoryProvider));
});

class GetAllUserUsecase implements UsecasewithoutParams<List<UserEntity>> {
  final IUserRespository _userRepository;

  GetAllUserUsecase({required IUserRespository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, List<UserEntity>>> call() {
    return _userRepository.getAllusers();
  }
}
