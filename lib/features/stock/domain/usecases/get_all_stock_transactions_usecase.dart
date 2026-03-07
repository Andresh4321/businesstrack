import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:businesstrack/features/stock/domain/entities/stock_entity.dart';
import 'package:businesstrack/features/stock/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllStockTransactionsUsecaseProvider =
    Provider<GetAllStockTransactionsUsecase>((ref) {
      final stockRepository = ref.read(stockRepositoryProvider);
      return GetAllStockTransactionsUsecase(stockRepository: stockRepository);
    });

class GetAllStockTransactionsUsecase
    implements UsecasewithoutParams<List<StockEntity>> {
  final IStockRepository _stockRepository;

  GetAllStockTransactionsUsecase({required IStockRepository stockRepository})
    : _stockRepository = stockRepository;

  @override
  Future<Either<Failure, List<StockEntity>>> call() {
    return _stockRepository.getAllStockTransactions();
  }
}
