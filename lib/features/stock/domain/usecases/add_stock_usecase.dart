import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:businesstrack/features/stock/domain/entities/stock_entity.dart';
import 'package:businesstrack/features/stock/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddStockParams extends Equatable {
  final String materialId;
  final double quantity;
  final String transactionType;
  final String? description;

  const AddStockParams({
    required this.materialId,
    required this.quantity,
    required this.transactionType,
    this.description,
  });

  @override
  List<Object?> get props => [
    materialId,
    quantity,
    transactionType,
    description,
  ];
}

final addStockUsecaseProvider = Provider<AddStockUsecase>((ref) {
  final stockRepository = ref.read(stockRepositoryProvider);
  return AddStockUsecase(stockRepository: stockRepository);
});

class AddStockUsecase implements UsecasewithParams<bool, AddStockParams> {
  final IStockRepository _stockRepository;

  AddStockUsecase({required IStockRepository stockRepository})
    : _stockRepository = stockRepository;

  @override
  Future<Either<Failure, bool>> call(AddStockParams params) {
    final entity = StockEntity(
      materialId: params.materialId,
      quantity: params.quantity,
      transactionType: params.transactionType,
      description: params.description,
    );
    return _stockRepository.addStock(entity);
  }
}
