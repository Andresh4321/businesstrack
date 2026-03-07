import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/production/data/repositories/production_repository_impl.dart';
import 'package:businesstrack/features/production/domain/repositories/production_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteProductionParams extends Equatable {
  final String productionId;

  const DeleteProductionParams({required this.productionId});

  @override
  List<Object?> get props => [productionId];
}

final deleteProductionUsecaseProvider = Provider<DeleteProductionUsecase>((
  ref,
) {
  final productionRepository = ref.read(productionRepositoryProvider);
  return DeleteProductionUsecase(productionRepository: productionRepository);
});

class DeleteProductionUsecase
    implements UsecasewithParams<bool, DeleteProductionParams> {
  final IProductionRepository _productionRepository;

  DeleteProductionUsecase({required IProductionRepository productionRepository})
    : _productionRepository = productionRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteProductionParams params) {
    return _productionRepository.deleteProduction(params.productionId);
  }
}
