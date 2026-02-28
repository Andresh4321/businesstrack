import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/stock/domain/entities/stock_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IStockRepository {
  Future<Either<Failure, List<StockEntity>>> getAllStock();
  Future<Either<Failure, List<StockEntity>>> getAllStockTransactions();
  Future<Either<Failure, StockEntity>> getStockById(String stockId);
  Future<Either<Failure, bool>> updateStock(StockEntity stock);
  Future<Either<Failure, bool>> addStock(StockEntity stock);
  Future<Either<Failure, bool>> deleteStock(String stockId);
  Future<Either<Failure, bool>> createStockTransaction({
    required String materialId,
    required double quantity,
    required String transactionType,
    String? description,
  });
  Future<Either<Failure, bool>> deleteStockTransaction(String transactionId);
}
