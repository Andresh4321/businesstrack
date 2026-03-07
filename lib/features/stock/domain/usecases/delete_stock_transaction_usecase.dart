import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:businesstrack/features/stock/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteStockTransactionParams extends Equatable {
  final String transactionId;

  const DeleteStockTransactionParams({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}

final deleteStockTransactionUsecaseProvider =
    Provider<DeleteStockTransactionUsecase>((ref) {
      final stockRepository = ref.read(stockRepositoryProvider);
      return DeleteStockTransactionUsecase(stockRepository: stockRepository);
    });

class DeleteStockTransactionUsecase
    implements UsecasewithParams<bool, DeleteStockTransactionParams> {
  final IStockRepository _stockRepository;

  DeleteStockTransactionUsecase({required IStockRepository stockRepository})
    : _stockRepository = stockRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteStockTransactionParams params) {
    return _stockRepository.deleteStockTransaction(params.transactionId);
  }
}
