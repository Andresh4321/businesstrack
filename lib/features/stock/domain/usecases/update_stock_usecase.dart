import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:businesstrack/features/stock/domain/entities/stock_entity.dart';
import 'package:businesstrack/features/stock/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateStockParams extends Equatable {
  final String stockId;
  final String? materialId;
  final int? quantity;
  final String? transactionType;
  final String? description;

  const UpdateStockParams({
    required this.stockId,
    this.materialId,
    this.quantity,
    this.transactionType,
    this.description,
  });

  @override
  List<Object?> get props => [
    stockId,
    materialId,
    quantity,
    transactionType,
    description,
  ];
}

final updateStockUsecaseProvider = Provider<UpdateStockUsecase>((ref) {
  final stockRepository = ref.read(stockRepositoryProvider);
  return UpdateStockUsecase(stockRepository: stockRepository);
});

class UpdateStockUsecase implements UsecasewithParams<bool, UpdateStockParams> {
  final IStockRepository _stockRepository;

  UpdateStockUsecase({required IStockRepository stockRepository})
    : _stockRepository = stockRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateStockParams params) {
    final entity = StockEntity(
      stockId: params.stockId,
      materialId: params.materialId ?? '',
      quantity: params.quantity?.toDouble() ?? 0.0,
      transactionType: params.transactionType ?? 'in',
      description: params.description,
    );
    return _stockRepository.updateStock(entity);
  }
}
