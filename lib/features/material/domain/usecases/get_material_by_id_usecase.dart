import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/material/data/repositories/material_repository_impl.dart';
import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:businesstrack/features/material/domain/repositories/material_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetMaterialByIdParams extends Equatable {
  final String materialId;

  const GetMaterialByIdParams({required this.materialId});

  @override
  List<Object?> get props => [materialId];
}

final getMaterialByIdUsecaseProvider = Provider<GetMaterialByIdUsecase>((ref) {
  final materialRepository = ref.read(materialRepositoryProvider);
  return GetMaterialByIdUsecase(materialRepository: materialRepository);
});

class GetMaterialByIdUsecase
    implements UsecasewithParams<MaterialEntity, GetMaterialByIdParams> {
  final IMaterialRepository _materialRepository;

  GetMaterialByIdUsecase({required IMaterialRepository materialRepository})
    : _materialRepository = materialRepository;

  @override
  Future<Either<Failure, MaterialEntity>> call(GetMaterialByIdParams params) {
    return _materialRepository.getMaterialById(params.materialId);
  }
}
