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
    if (await _networkInfo.isConnected) {
      try {
        final model = ProductionModel.fromEntity(production);
        final result = await _productionRemoteDatasource.startProduction(model);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          Apifailure(
            message: _extractApiMessage(e, 'Failed to start production'),
          ),
        );
      }
    } else {
      try {
        final model = ProductionModel.fromEntity(production);
        final result = await _productionLocalDatasource.startProduction(model);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> endProduction(
    String productionId, {
    double? actualOutput,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _productionRemoteDatasource.endProduction(
          productionId,
          actualOutput: actualOutput,
        );
        return Right(result);
      } on DioException catch (e) {
        return Left(
          Apifailure(
            message: _extractApiMessage(e, 'Failed to end production'),
          ),
        );
      }
    } else {
      try {
        final result = await _productionLocalDatasource.endProduction(
          productionId,
          actualOutput: actualOutput,
        );
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ProductionEntity>>> getAllProduction() async {
    if (await _networkInfo.isConnected) {
      try {
        final production = await _productionRemoteDatasource.getAllProduction();
        return Right(ProductionModel.toEntityList(production));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: _extractApiMessage(e, 'Failed to fetch production'),
          ),
        );
      }
    } else {
      try {
        final production = await _productionLocalDatasource.getAllProduction();
        return Right(ProductionModel.toEntityList(production));
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, ProductionEntity>> getProductionById(
    String productionId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final production = await _productionRemoteDatasource.getProductionById(
          productionId,
        );
        if (production != null) {
          return Right(production.toEntity());
        }
        return Left(Apifailure(message: 'Production not found'));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: _extractApiMessage(e, 'Failed to fetch production'),
          ),
        );
      }
    } else {
      try {
        final production = await _productionLocalDatasource.getProductionById(
          productionId,
        );
        if (production != null) {
          return Right(production.toEntity());
        }
        return Left(LocalDatabaseFailure(messgae: 'Production not found'));
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> updateProduction(
    ProductionEntity production,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = ProductionModel.fromEntity(production);
        final result = await _productionRemoteDatasource.updateProduction(
          model,
        );
        return Right(result);
      } on DioException catch (e) {
        return Left(
          Apifailure(
            message: _extractApiMessage(e, 'Failed to update production'),
          ),
        );
      }
    } else {
      try {
        final model = ProductionModel.fromEntity(production);
        final result = await _productionLocalDatasource.updateProduction(model);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduction(String productionId) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _productionRemoteDatasource.deleteProduction(
          productionId,
        );
        return Right(result);
      } on DioException catch (e) {
        return Left(
          Apifailure(
            message: _extractApiMessage(e, 'Failed to delete production'),
          ),
        );
      }
    } else {
      try {
        final result = await _productionLocalDatasource.deleteProduction(
          productionId,
        );
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }
}
