import 'dart:io';

import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/users/data/repositories/user_repository.dart';
import 'package:businesstrack/features/users/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final UploadPhotoUsecaseProvider = Provider<UploadPhotoUsecase>((ref) {
  final UserRepository = ref.read(UserRepositoryProvider);
  return UploadPhotoUsecase(userRespository: UserRepository);
});

class UploadPhotoUsecase implements UsecasewithParams<String, File> {
  final IUserRespository _iUserRespository;
  UploadPhotoUsecase({required IUserRespository userRespository})
    : _iUserRespository = userRespository;

  @override
  Future<Either<Failure, String>> call(File params) {
    return _iUserRespository.uploadImage(params);
  }
}
