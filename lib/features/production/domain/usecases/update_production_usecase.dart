import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/production/data/repositories/production_repository_impl.dart';
import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:businesstrack/features/production/domain/repositories/production_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateProductionParams extends Equatable {
  final ProductionEntity production;

  const UpdateProductionParams({required this.production});

  @override
  List<Object?> get props => [production];
}

final updateProductionUsecaseProvider = Provider<UpdateProductionUsecase>((
  ref,
) {
  final productionRepository = ref.read(productionRepositoryProvider);
  return UpdateProductionUsecase(productionRepository: productionRepository);
});

class UpdateProductionUsecase
    implements UsecasewithParams<bool, UpdateProductionParams> {
  final IProductionRepository _productionRepository;

  UpdateProductionUsecase({required IProductionRepository productionRepository})
    : _productionRepository = productionRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateProductionParams params) {
    return _productionRepository.updateProduction(params.production);
  }
}
