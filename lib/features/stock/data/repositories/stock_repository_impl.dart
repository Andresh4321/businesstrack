import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/services/connectivity/network_info.dart';
import 'package:businesstrack/features/stock/data/datasources/local/stock_local_datasource.dart';
import 'package:businesstrack/features/stock/data/datasources/remote/stock_remote_datasource.dart';
import 'package:businesstrack/features/stock/data/datasources/stock_datasource.dart';
import 'package:businesstrack/features/stock/data/models/stock_model.dart';
import 'package:businesstrack/features/stock/domain/entities/stock_entity.dart';
import 'package:businesstrack/features/stock/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stockRepositoryProvider = Provider<IStockRepository>((ref) {
  final stockLocalDatasource = ref.read(stockLocalDatasourceProvider);
  final stockRemoteDatasource = ref.read(stockRemoteProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return StockRepositoryImpl(
    stockLocalDatasource: stockLocalDatasource,
    stockRemoteDatasource: stockRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class StockRepositoryImpl implements IStockRepository {
  final IStockDataSource _stockLocalDatasource;
  final IStockRemoteDataSource _stockRemoteDatasource;
  final NetworkInfo _networkInfo;

  StockRepositoryImpl({
    required IStockDataSource stockLocalDatasource,
    required IStockRemoteDataSource stockRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _stockLocalDatasource = stockLocalDatasource,
       _stockRemoteDatasource = stockRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> addStock(StockEntity stock) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = StockModel.fromEntity(stock);
        final result = await _stockRemoteDatasource.addStock(model);
        return Right(result);
      } on DioException catch (e) {
        return Left(Apifailure(message: e.message ?? 'Failed to add stock'));
      }
    } else {
      try {
        final model = StockModel.fromEntity(stock);
        final result = await _stockLocalDatasource.addStock(model);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteStock(String stockId) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _stockRemoteDatasource.deleteStock(stockId);
        return Right(result);
      } on DioException catch (e) {
        return Left(Apifailure(message: e.message ?? 'Failed to delete stock'));
      }
    } else {
      try {
        final result = await _stockLocalDatasource.deleteStock(stockId);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<StockEntity>>> getAllStock() async {
    if (await _networkInfo.isConnected) {
      try {
        final stock = await _stockRemoteDatasource.getAllStock();
        return Right(StockModel.toEntityList(stock));
      } on DioException catch (e) {
        return Left(Apifailure(message: e.message ?? 'Failed to fetch stock'));
      }
    } else {
      try {
        final stock = await _stockLocalDatasource.getAllStock();
        return Right(StockModel.toEntityList(stock));
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, StockEntity>> getStockById(String stockId) async {
    if (await _networkInfo.isConnected) {
      try {
        final stock = await _stockRemoteDatasource.getStockById(stockId);
        if (stock != null) {
          return Right(stock.toEntity());
        }
        return Left(Apifailure(message: 'Stock not found'));
      } on DioException catch (e) {
        return Left(Apifailure(message: e.message ?? 'Failed to fetch stock'));
      }
    } else {
      try {
        final stock = await _stockLocalDatasource.getStockById(stockId);
        if (stock != null) {
          return Right(stock.toEntity());
        }
        return Left(LocalDatabaseFailure(messgae: 'Stock not found'));
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> updateStock(StockEntity stock) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = StockModel.fromEntity(stock);
        final result = await _stockRemoteDatasource.updateStock(model);
        return Right(result);
      } on DioException catch (e) {
        return Left(Apifailure(message: e.message ?? 'Failed to update stock'));
      }
    } else {
      try {
        final model = StockModel.fromEntity(stock);
        final result = await _stockLocalDatasource.updateStock(model);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<StockEntity>>> getAllStockTransactions() async {
    if (await _networkInfo.isConnected) {
      try {
        final stock = await _stockRemoteDatasource.getAllStock();
        return Right(StockModel.toEntityList(stock));
      } on DioException catch (e) {
        return Left(
          Apifailure(message: e.message ?? 'Failed to fetch transactions'),
        );
      }
    } else {
      try {
        final stock = await _stockLocalDatasource.getAllStock();
        return Right(StockModel.toEntityList(stock));
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> createStockTransaction({
    required String materialId,
    required double quantity,
    required String transactionType,
    String? description,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _stockRemoteDatasource.createStockTransaction(
          materialId: materialId,
          quantity: quantity,
          transactionType: transactionType,
          description: description,
        );
        return Right(result);
      } on DioException catch (e) {
        return Left(
          Apifailure(message: e.message ?? 'Failed to create transaction'),
        );
      }
    } else {
      return Left(Apifailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteStockTransaction(
    String transactionId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _stockRemoteDatasource.deleteStock(transactionId);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          Apifailure(message: e.message ?? 'Failed to delete transaction'),
        );
      }
    } else {
      return Left(Apifailure(message: 'No internet connection'));
    }
  }
}
