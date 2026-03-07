import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:businesstrack/features/stock/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateStockTransactionParams extends Equatable {
  final String materialId;
  final double quantity;
  final String transactionType;
  final String? description;

  const CreateStockTransactionParams({
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

final createStockTransactionUsecaseProvider =
    Provider<CreateStockTransactionUsecase>((ref) {
      final stockRepository = ref.read(stockRepositoryProvider);
      return CreateStockTransactionUsecase(stockRepository: stockRepository);
    });

class CreateStockTransactionUsecase
    implements UsecasewithParams<bool, CreateStockTransactionParams> {
  final IStockRepository _stockRepository;

  CreateStockTransactionUsecase({required IStockRepository stockRepository})
    : _stockRepository = stockRepository;

  @override
  Future<Either<Failure, bool>> call(CreateStockTransactionParams params) {
    return _stockRepository.createStockTransaction(
      materialId: params.materialId,
      quantity: params.quantity,
      transactionType: params.transactionType,
      description: params.description,
    );
  }
}
