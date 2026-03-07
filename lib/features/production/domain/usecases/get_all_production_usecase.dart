import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/production/data/repositories/production_repository_impl.dart';
import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:businesstrack/features/production/domain/repositories/production_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllProductionUsecaseProvider = Provider<GetAllProductionUsecase>((
  ref,
) {
  final productionRepository = ref.read(productionRepositoryProvider);
  return GetAllProductionUsecase(productionRepository: productionRepository);
});

class GetAllProductionUsecase
    implements UsecasewithoutParams<List<ProductionEntity>> {
  final IProductionRepository _productionRepository;

  GetAllProductionUsecase({required IProductionRepository productionRepository})
    : _productionRepository = productionRepository;

  @override
  Future<Either<Failure, List<ProductionEntity>>> call() {
    return _productionRepository.getAllProduction();
  }
}
