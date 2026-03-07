import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/production/data/repositories/production_repository_impl.dart';
import 'package:businesstrack/features/production/domain/repositories/production_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EndProductionParams extends Equatable {
  final String productionId;
  final double? actualOutput;

  const EndProductionParams({required this.productionId, this.actualOutput});

  @override
  List<Object?> get props => [productionId, actualOutput];
}

final endProductionUsecaseProvider = Provider<EndProductionUsecase>((ref) {
  final productionRepository = ref.read(productionRepositoryProvider);
  return EndProductionUsecase(productionRepository: productionRepository);
});

class EndProductionUsecase
    implements UsecasewithParams<bool, EndProductionParams> {
  final IProductionRepository _productionRepository;

  EndProductionUsecase({required IProductionRepository productionRepository})
    : _productionRepository = productionRepository;

  @override
  Future<Either<Failure, bool>> call(EndProductionParams params) {
    return _productionRepository.endProduction(
      params.productionId,
      actualOutput: params.actualOutput,
    );
  }
}
