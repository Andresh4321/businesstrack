import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/users/data/repositories/user_repository.dart';
import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:businesstrack/features/users/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class UpdateuserUsecaseParams extends Equatable {
  final String userId;
  final String userName;
  final String? status;

  const UpdateuserUsecaseParams({
    required this.userId,
    required this.userName,
    this.status,
  });

  @override
  
  List<Object?> get props =>[userId, userName, status];

}

//Usecase
final updateuserUsecaseProvider = Provider<UpdateuserUsecase>((ref){
  return UpdateuserUsecase(userRepository: ref.read(UserRepositoryProvider));
});

class UpdateuserUsecase implements UsecasewithParams<bool, UpdateuserUsecaseParams>{
    final IUserRespository _userRepository;

  UpdateuserUsecase({required IUserRespository userRepository})
  : _userRepository = userRepository;
  
  @override
  Future<Either<Failure, bool>> createuser(UpdateuserUsecaseParams params) {
  UserEntity userEntity = UserEntity(
    userId: params.userId,
    username: params.userName,

    status: params.status,
  );

  return _userRepository.updateuser(userEntity);
  }
  
  @override
  Future<Either<Failure, bool>> call(UpdateuserUsecaseParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }

}

