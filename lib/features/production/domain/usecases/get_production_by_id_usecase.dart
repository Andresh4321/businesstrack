import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/production/data/repositories/production_repository_impl.dart';
import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:businesstrack/features/production/domain/repositories/production_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetProductionByIdParams extends Equatable {
  final String productionId;

  const GetProductionByIdParams({required this.productionId});

  @override
  List<Object?> get props => [productionId];
}

final getProductionByIdUsecaseProvider = Provider<GetProductionByIdUsecase>((
  ref,
) {
  final productionRepository = ref.read(productionRepositoryProvider);
  return GetProductionByIdUsecase(productionRepository: productionRepository);
});

class GetProductionByIdUsecase
    implements UsecasewithParams<ProductionEntity, GetProductionByIdParams> {
  final IProductionRepository _productionRepository;

  GetProductionByIdUsecase({
    required IProductionRepository productionRepository,
  }) : _productionRepository = productionRepository;

  @override
  Future<Either<Failure, ProductionEntity>> call(
    GetProductionByIdParams params,
  ) {
    return _productionRepository.getProductionById(params.productionId);
  }
}
