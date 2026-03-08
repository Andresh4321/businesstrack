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

  List<StockEntity> _sortByLatest(List<StockEntity> items) {
    final sorted = List<StockEntity>.from(items);
    sorted.sort((a, b) {
      final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
    return sorted;
  }

  Future<void> _cacheRemoteStocksToLocal(List<StockModel> remoteStock) async {
    for (final item in remoteStock) {
      try {
        await _stockLocalDatasource.addStock(item);
      } catch (_) {
        // Best-effort cache; ignore single-item failure.
      }
    }
  }

  @override
  Future<Either<Failure, bool>> addStock(StockEntity stock) async {
    try {
      final model = StockModel.fromEntity(stock);

      // Always write to Hive first so offline mode works.
      final localResult = await _stockLocalDatasource.addStock(model);
      if (!localResult) {
        return Left(
          LocalDatabaseFailure(messgae: 'Failed to save stock locally'),
        );
      }

      // Best-effort remote sync when online (non-blocking for UX).
      if (await _networkInfo.isConnected) {
        try {
          await _stockRemoteDatasource.addStock(model);
        } catch (_) {}
      }

      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteStock(String stockId) async {
    try {
      final localResult = await _stockLocalDatasource.deleteStock(stockId);
      if (!localResult) {
        return Left(
          LocalDatabaseFailure(messgae: 'Failed to delete stock locally'),
        );
      }

      if (await _networkInfo.isConnected) {
        try {
          await _stockRemoteDatasource.deleteStock(stockId);
        } catch (_) {}
      }

      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StockEntity>>> getAllStock() async {
    try {
      final localStock = await _stockLocalDatasource.getAllStock();

      if (localStock.isNotEmpty || !(await _networkInfo.isConnected)) {
        return Right(_sortByLatest(StockModel.toEntityList(localStock)));
      }

      final remoteStock = await _stockRemoteDatasource.getAllStock();
      await _cacheRemoteStocksToLocal(remoteStock);
      return Right(_sortByLatest(StockModel.toEntityList(remoteStock)));
    } on DioException catch (e) {
      return Left(Apifailure(message: e.message ?? 'Failed to fetch stock'));
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, StockEntity>> getStockById(String stockId) async {
    try {
      final localStock = await _stockLocalDatasource.getStockById(stockId);
      if (localStock != null) {
        return Right(localStock.toEntity());
      }

      if (await _networkInfo.isConnected) {
        final remoteStock = await _stockRemoteDatasource.getStockById(stockId);
        if (remoteStock != null) {
          try {
            await _stockLocalDatasource.addStock(remoteStock);
          } catch (_) {}
          return Right(remoteStock.toEntity());
        }
      }

      return Left(LocalDatabaseFailure(messgae: 'Stock not found'));
    } on DioException catch (e) {
      return Left(Apifailure(message: e.message ?? 'Failed to fetch stock'));
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateStock(StockEntity stock) async {
    try {
      final model = StockModel.fromEntity(stock);
      final localResult = await _stockLocalDatasource.updateStock(model);
      if (!localResult) {
        return Left(
          LocalDatabaseFailure(messgae: 'Failed to update stock locally'),
        );
      }

      if (await _networkInfo.isConnected) {
        try {
          await _stockRemoteDatasource.updateStock(model);
        } catch (_) {}
      }

      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StockEntity>>> getAllStockTransactions() async {
    try {
      final localStock = await _stockLocalDatasource.getAllStock();

      if (localStock.isNotEmpty || !(await _networkInfo.isConnected)) {
        return Right(_sortByLatest(StockModel.toEntityList(localStock)));
      }

      final remoteStock = await _stockRemoteDatasource.getAllStock();
      await _cacheRemoteStocksToLocal(remoteStock);
      return Right(_sortByLatest(StockModel.toEntityList(remoteStock)));
    } on DioException catch (e) {
      return Left(
        Apifailure(message: e.message ?? 'Failed to fetch transactions'),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createStockTransaction({
    required String materialId,
    required double quantity,
    required String transactionType,
    String? description,
  }) async {
    try {
      final model = StockModel(
        materialId: materialId,
        quantity: quantity,
        transactionType: transactionType,
        description: description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Always store transaction in Hive first.
      final localResult = await _stockLocalDatasource.addStock(model);
      if (!localResult) {
        return Left(
          LocalDatabaseFailure(messgae: 'Failed to save transaction locally'),
        );
      }

      // Best-effort remote sync if online.
      if (await _networkInfo.isConnected) {
        try {
          await _stockRemoteDatasource.createStockTransaction(
            materialId: materialId,
            quantity: quantity,
            transactionType: transactionType,
            description: description,
          );
        } catch (_) {}
      }

      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteStockTransaction(
    String transactionId,
  ) async {
    try {
      final localResult = await _stockLocalDatasource.deleteStock(
        transactionId,
      );
      if (!localResult) {
        return Left(
          LocalDatabaseFailure(messgae: 'Failed to delete transaction locally'),
        );
      }

      if (await _networkInfo.isConnected) {
        try {
          await _stockRemoteDatasource.deleteStock(transactionId);
        } catch (_) {}
      }

      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }
}
