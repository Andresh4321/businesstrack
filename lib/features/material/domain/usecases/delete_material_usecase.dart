import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/material/data/repositories/material_repository_impl.dart';
import 'package:businesstrack/features/material/domain/repositories/material_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteMaterialParams extends Equatable {
  final String materialId;

  const DeleteMaterialParams({required this.materialId});

  @override
  List<Object?> get props => [materialId];
}

final deleteMaterialUsecaseProvider = Provider<DeleteMaterialUsecase>((ref) {
  final materialRepository = ref.read(materialRepositoryProvider);
  return DeleteMaterialUsecase(materialRepository: materialRepository);
});

class DeleteMaterialUsecase
    implements UsecasewithParams<bool, DeleteMaterialParams> {
  final IMaterialRepository _materialRepository;

  DeleteMaterialUsecase({required IMaterialRepository materialRepository})
    : _materialRepository = materialRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteMaterialParams params) {
    return _materialRepository.deleteMaterial(params.materialId);
  }
}
