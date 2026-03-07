import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/material/data/repositories/material_repository_impl.dart';
import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:businesstrack/features/material/domain/repositories/material_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllMaterialsUsecaseProvider = Provider<GetAllMaterialsUsecase>((ref) {
  final materialRepository = ref.read(materialRepositoryProvider);
  return GetAllMaterialsUsecase(materialRepository: materialRepository);
});

class GetAllMaterialsUsecase
    implements UsecasewithoutParams<List<MaterialEntity>> {
  final IMaterialRepository _materialRepository;

  GetAllMaterialsUsecase({required IMaterialRepository materialRepository})
    : _materialRepository = materialRepository;

  @override
  Future<Either<Failure, List<MaterialEntity>>> call() {
    return _materialRepository.getAllMaterials();
  }
}
