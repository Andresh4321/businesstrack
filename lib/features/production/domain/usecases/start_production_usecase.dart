import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/production/data/repositories/production_repository_impl.dart';
import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:businesstrack/features/production/domain/repositories/production_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartProductionParams extends Equatable {
  final String? batchId;
  final String? recipeId;
  final int? quantity;
  final double? estimatedOutput;
  final String? notes;

  const StartProductionParams({
    this.batchId,
    this.recipeId,
    this.quantity,
    this.estimatedOutput,
    this.notes,
  });

  @override
  List<Object?> get props => [
    batchId,
    recipeId,
    quantity,
    estimatedOutput,
    notes,
  ];
}

final startProductionUsecaseProvider = Provider<StartProductionUsecase>((ref) {
  final productionRepository = ref.read(productionRepositoryProvider);
  return StartProductionUsecase(productionRepository: productionRepository);
});

class StartProductionUsecase
    implements UsecasewithParams<bool, StartProductionParams> {
  final IProductionRepository _productionRepository;

  StartProductionUsecase({required IProductionRepository productionRepository})
    : _productionRepository = productionRepository;

  @override
  Future<Either<Failure, bool>> call(StartProductionParams params) {
    final resolvedQuantity = (params.quantity ?? 0).toDouble();
    final entity = ProductionEntity(
      recipeId: params.recipeId ?? '',
      batchQuantity: resolvedQuantity,
      estimatedOutput: params.estimatedOutput ?? resolvedQuantity,
      itemsUsed: const [],
      status: 'ongoing',
    );
    return _productionRepository.startProduction(entity);
  }
}
