import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IMaterialRepository {
  Future<Either<Failure, List<MaterialEntity>>> getAllMaterials();
  Future<Either<Failure, MaterialEntity>> getMaterialById(String materialId);
  Future<Either<Failure, bool>> addMaterial(MaterialEntity material);
  Future<Either<Failure, bool>> updateMaterial(MaterialEntity material);
  Future<Either<Failure, bool>> deleteMaterial(String materialId);
  Future<Either<Failure, List<MaterialEntity>>> searchMaterials(String query);
}
