import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/auth/data/repositories/auth_repository.dart';
import 'package:businesstrack/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadPhotoParams extends Equatable {
  final String filePath;

  const UploadPhotoParams({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

final uploadPhotoUsecaseProvider = Provider<UploadPhotoUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return UploadPhotoUsecase(repository: repository);
});

class UploadPhotoUsecase
    implements UsecasewithParams<String, UploadPhotoParams> {
  final IAuthRespository _repository;

  UploadPhotoUsecase({required IAuthRespository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, String>> call(UploadPhotoParams params) {
    return _repository.uploadPhoto(params.filePath);
  }
}
