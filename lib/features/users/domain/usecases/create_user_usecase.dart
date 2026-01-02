//Params

import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/users/data/repositories/user_repository.dart';
import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:businesstrack/features/users/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateuserUsecaseParams extends Equatable {
  final String userName;

  const CreateuserUsecaseParams({required this.userName});

  @override
  // TODO: implement props
  List<Object?> get props => [userName];
  }
  final createuserUsecaseProvider = Provider<CreateuserUsecase>((ref){
    return CreateuserUsecase(userRepository: ref.read(UserRepositoryProvider));
  });

//Usecase

class CreateuserUsecase implements UsecasewithParams<bool, CreateuserUsecaseParams>{
  final IUserRespository _userRepository;

  CreateuserUsecase({required IUserRespository userRepository})
  : _userRepository = userRepository;
  
  @override
  Future<Either<Failure, bool>> call(CreateuserUsecaseParams params) {

    throw UnimplementedError();

  }
  
  @override
  Future<Either<Failure, bool>> createuser(CreateuserUsecaseParams params) {
    UserEntity userEntity = UserEntity(username: params.userName);
   return _userRepository.createuser(userEntity);
  }}