import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IProductionRepository {
  Future<Either<Failure, List<ProductionEntity>>> getAllProduction();
  Future<Either<Failure, ProductionEntity>> getProductionById(
    String productionId,
  );
  Future<Either<Failure, bool>> startProduction(ProductionEntity production);
  Future<Either<Failure, bool>> updateProduction(ProductionEntity production);
  Future<Either<Failure, bool>> endProduction(
    String productionId, {
    double? actualOutput,
  });
  Future<Either<Failure, bool>> deleteProduction(String productionId);
}
