import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/services/connectivity/network_info.dart';
import 'package:businesstrack/features/low_stock_alert/data/datasources/local/low_stock_alert_local_datasource.dart';
import 'package:businesstrack/features/low_stock_alert/data/datasources/low_stock_alert_datasource.dart';
import 'package:businesstrack/features/low_stock_alert/data/datasources/remote/low_stock_alert_remote_datasource.dart';
import 'package:businesstrack/features/low_stock_alert/data/datasources/remote/low_stock_alert_remote_datasource_impl.dart';
import 'package:businesstrack/features/low_stock_alert/data/models/low_stock_alert_model.dart';
import 'package:businesstrack/features/low_stock_alert/domain/entities/low_stock_alert_entity.dart';
import 'package:businesstrack/features/low_stock_alert/domain/repositories/low_stock_alert_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lowStockAlertRepositoryProvider = Provider<ILowStockAlertRepository>((
  ref,
) {
  final lowStockAlertLocalDatasource = ref.read(
    lowStockAlertLocalDatasourceProvider,
  );
  final lowStockAlertRemoteDatasource = ref.read(lowStockAlertRemoteProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return LowStockAlertRepositoryImpl(
    lowStockAlertLocalDatasource: lowStockAlertLocalDatasource,
    lowStockAlertRemoteDatasource: lowStockAlertRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class LowStockAlertRepositoryImpl implements ILowStockAlertRepository {
  final ILowStockAlertDataSource _lowStockAlertLocalDatasource;
  final ILowStockAlertRemoteDataSource _lowStockAlertRemoteDatasource;
  final NetworkInfo _networkInfo;

  LowStockAlertRepositoryImpl({
    required ILowStockAlertDataSource lowStockAlertLocalDatasource,
    required ILowStockAlertRemoteDataSource lowStockAlertRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _lowStockAlertLocalDatasource = lowStockAlertLocalDatasource,
       _lowStockAlertRemoteDatasource = lowStockAlertRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<LowStockAlertEntity>>> getAllAlerts() async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _lowStockAlertRemoteDatasource.getAllAlerts();

        // Cache alerts locally
        for (var alert in result) {
          await _lowStockAlertLocalDatasource.saveAlert(alert);
        }

        return Right(LowStockAlertModel.toEntityList(result));
      } on DioException catch (e) {
        return Left(ApiFailure(message: e.message ?? 'Failed to fetch alerts'));
      }
    } else {
      try {
        final result = await _lowStockAlertLocalDatasource.getAllAlerts();
        return Right(LowStockAlertModel.toEntityList(result));
      } catch (e) {
        return Left(CacheFailure(message: 'Failed to load alerts from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, List<LowStockAlertEntity>>>
  getUnresolvedAlerts() async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _lowStockAlertRemoteDatasource
            .getUnresolvedAlerts();

        // Cache alerts locally
        for (var alert in result) {
          await _lowStockAlertLocalDatasource.saveAlert(alert);
        }

        return Right(LowStockAlertModel.toEntityList(result));
      } on DioException catch (e) {
        return Left(
          ApiFailure(message: e.message ?? 'Failed to fetch unresolved alerts'),
        );
      }
    } else {
      try {
        final result = await _lowStockAlertLocalDatasource
            .getUnresolvedAlerts();
        return Right(LowStockAlertModel.toEntityList(result));
      } catch (e) {
        return Left(
          CacheFailure(message: 'Failed to load unresolved alerts from cache'),
        );
      }
    }
  }

  @override
  Future<Either<Failure, LowStockAlertEntity>> getAlertById(
    String alertId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _lowStockAlertRemoteDatasource.getAlertById(
          alertId,
        );
        await _lowStockAlertLocalDatasource.saveAlert(result);
        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(ApiFailure(message: e.message ?? 'Failed to fetch alert'));
      }
    } else {
      try {
        final result = await _lowStockAlertLocalDatasource.getAlertById(
          alertId,
        );
        return Right(result.toEntity());
      } catch (e) {
        return Left(CacheFailure(message: 'Failed to load alert from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> createAlert(LowStockAlertEntity alert) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = LowStockAlertModel.fromEntity(alert);
        final result = await _lowStockAlertRemoteDatasource.createAlert(model);
        await _lowStockAlertLocalDatasource.saveAlert(model);
        return Right(result);
      } on DioException catch (e) {
        return Left(ApiFailure(message: e.message ?? 'Failed to create alert'));
      }
    } else {
      try {
        final model = LowStockAlertModel.fromEntity(alert);
        final result = await _lowStockAlertLocalDatasource.saveAlert(model);
        return Right(result);
      } catch (e) {
        return Left(CacheFailure(message: 'Failed to save alert locally'));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> resolveAlert(
    String alertId,
    String resolvedBy,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _lowStockAlertRemoteDatasource.resolveAlert(
          alertId,
          resolvedBy,
        );

        // Update local cache
        try {
          final localAlert = await _lowStockAlertLocalDatasource.getAlertById(
            alertId,
          );
          final updatedAlert = LowStockAlertModel(
            alertId: localAlert.alertId,
            materialId: localAlert.materialId,
            materialName: localAlert.materialName,
            currentQuantity: localAlert.currentQuantity,
            thresholdQuantity: localAlert.thresholdQuantity,
            severity: localAlert.severity,
            isResolved: true,
            createdAt: localAlert.createdAt,
            updatedAt: DateTime.now(),
            resolvedBy: resolvedBy,
            resolvedAt: DateTime.now(),
          );
          await _lowStockAlertLocalDatasource.updateAlert(updatedAlert);
        } catch (e) {
          // If local update fails, it's not critical
        }

        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(message: e.message ?? 'Failed to resolve alert'),
        );
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAlert(String alertId) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _lowStockAlertRemoteDatasource.deleteAlert(
          alertId,
        );
        await _lowStockAlertLocalDatasource.deleteAlert(alertId);
        return Right(result);
      } on DioException catch (e) {
        return Left(ApiFailure(message: e.message ?? 'Failed to delete alert'));
      }
    } else {
      try {
        final result = await _lowStockAlertLocalDatasource.deleteAlert(alertId);
        return Right(result);
      } catch (e) {
        return Left(CacheFailure(message: 'Failed to delete alert from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, List<LowStockAlertEntity>>>
  checkLowStockItems() async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _lowStockAlertRemoteDatasource
            .checkLowStockItems();

        // Cache alerts locally
        for (var alert in result) {
          await _lowStockAlertLocalDatasource.saveAlert(alert);
        }

        return Right(LowStockAlertModel.toEntityList(result));
      } on DioException catch (e) {
        return Left(
          ApiFailure(message: e.message ?? 'Failed to check low stock items'),
        );
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
