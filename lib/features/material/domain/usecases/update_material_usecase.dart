import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/material/data/repositories/material_repository_impl.dart';
import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:businesstrack/features/material/domain/repositories/material_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateMaterialParams extends Equatable {
  final MaterialEntity material;

  const UpdateMaterialParams({required this.material});

  @override
  List<Object?> get props => [material];
}

final updateMaterialUsecaseProvider = Provider<UpdateMaterialUsecase>((ref) {
  final materialRepository = ref.read(materialRepositoryProvider);
  return UpdateMaterialUsecase(materialRepository: materialRepository);
});

class UpdateMaterialUsecase
    implements UsecasewithParams<bool, UpdateMaterialParams> {
  final IMaterialRepository _materialRepository;

  UpdateMaterialUsecase({required IMaterialRepository materialRepository})
    : _materialRepository = materialRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateMaterialParams params) {
    return _materialRepository.updateMaterial(params.material);
  }
}
