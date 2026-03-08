import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/services/connectivity/network_info.dart';
import 'package:businesstrack/features/production/data/datasources/local/production_local_datasource.dart';
import 'package:businesstrack/features/production/data/datasources/production_datasource.dart';
import 'package:businesstrack/features/production/data/datasources/remote/production_remote_datasource.dart';
import 'package:businesstrack/features/production/data/models/production_model.dart';
import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:businesstrack/features/production/domain/repositories/production_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productionRepositoryProvider = Provider<IProductionRepository>((ref) {
  final productionLocalDatasource = ref.read(productionLocalDatasourceProvider);
  final productionRemoteDatasource = ref.read(productionRemoteProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return ProductionRepositoryImpl(
    productionLocalDatasource: productionLocalDatasource,
    productionRemoteDatasource: productionRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class ProductionRepositoryImpl implements IProductionRepository {
  final IProductionDataSource _productionLocalDatasource;
  final IProductionRemoteDataSource _productionRemoteDatasource;
  final NetworkInfo _networkInfo;

  ProductionRepositoryImpl({
    required IProductionDataSource productionLocalDatasource,
    required IProductionRemoteDataSource productionRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _productionLocalDatasource = productionLocalDatasource,
       _productionRemoteDatasource = productionRemoteDatasource,
       _networkInfo = networkInfo;

  List<ProductionEntity> _sortByLatest(List<ProductionEntity> items) {
    final sorted = List<ProductionEntity>.from(items);
    sorted.sort((a, b) {
      final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
    return sorted;
  }

  Future<void> _cacheRemoteToLocal(List<ProductionModel> remoteItems) async {
    for (final item in remoteItems) {
      try {
        await _productionLocalDatasource.startProduction(item);
      } catch (_) {}
    }
  }

  String _extractApiMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }
    return e.message ?? fallback;
  }

  @override
  Future<Either<Failure, bool>> startProduction(
    ProductionEntity production,
  ) async {
    try {
      final model = ProductionModel.fromEntity(production);

      final localResult = await _productionLocalDatasource.startProduction(
        model,
      );
      if (!localResult) {
        return Left(
          LocalDatabaseFailure(messgae: 'Failed to save production locally'),
        );
      }

      if (await _networkInfo.isConnected) {
        try {
          await _productionRemoteDatasource.startProduction(model);
        } catch (_) {}
      }

      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> endProduction(
    String productionId, {
    double? actualOutput,
  }) async {
    try {
      final localResult = await _productionLocalDatasource.endProduction(
        productionId,
        actualOutput: actualOutput,
      );
      if (!localResult) {
        return Left(
          LocalDatabaseFailure(messgae: 'Failed to end production locally'),
        );
      }

      if (await _networkInfo.isConnected) {
        try {
          await _productionRemoteDatasource.endProduction(
            productionId,
            actualOutput: actualOutput,
          );
        } catch (_) {}
      }

      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductionEntity>>> getAllProduction() async {
    try {
      final localProduction = await _productionLocalDatasource
          .getAllProduction();

      if (localProduction.isNotEmpty || !(await _networkInfo.isConnected)) {
        return Right(
          _sortByLatest(ProductionModel.toEntityList(localProduction)),
        );
      }

      final remoteProduction = await _productionRemoteDatasource
          .getAllProduction();
      await _cacheRemoteToLocal(remoteProduction);
      return Right(
        _sortByLatest(ProductionModel.toEntityList(remoteProduction)),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _extractApiMessage(e, 'Failed to fetch production'),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductionEntity>> getProductionById(
    String productionId,
  ) async {
    try {
      final localProduction = await _productionLocalDatasource
          .getProductionById(productionId);
      if (localProduction != null) {
        return Right(localProduction.toEntity());
      }

      if (await _networkInfo.isConnected) {
        final remoteProduction = await _productionRemoteDatasource
            .getProductionById(productionId);
        if (remoteProduction != null) {
          try {
            await _productionLocalDatasource.startProduction(remoteProduction);
          } catch (_) {}
          return Right(remoteProduction.toEntity());
        }
      }

      return Left(LocalDatabaseFailure(messgae: 'Production not found'));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _extractApiMessage(e, 'Failed to fetch production'),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateProduction(
    ProductionEntity production,
  ) async {
    try {
      final model = ProductionModel.fromEntity(production);
      final localResult = await _productionLocalDatasource.updateProduction(
        model,
      );
      if (!localResult) {
        return Left(
          LocalDatabaseFailure(messgae: 'Failed to update production locally'),
        );
      }

      if (await _networkInfo.isConnected) {
        try {
          await _productionRemoteDatasource.updateProduction(model);
        } catch (_) {}
      }

      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduction(String productionId) async {
    try {
      final localResult = await _productionLocalDatasource.deleteProduction(
        productionId,
      );
      if (!localResult) {
        return Left(
          LocalDatabaseFailure(messgae: 'Failed to delete production locally'),
        );
      }

      if (await _networkInfo.isConnected) {
        try {
          await _productionRemoteDatasource.deleteProduction(productionId);
        } catch (_) {}
      }

      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }
}
