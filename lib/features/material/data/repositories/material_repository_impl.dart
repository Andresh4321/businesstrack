import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/services/connectivity/network_info.dart';
import 'package:businesstrack/features/material/data/datasources/local/material_local_datasource.dart';
import 'package:businesstrack/features/material/data/datasources/material_datasource.dart';
import 'package:businesstrack/features/material/data/datasources/remote/material_remote_datasource.dart';
import 'package:businesstrack/features/material/data/models/material_model.dart';
import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:businesstrack/features/material/domain/repositories/material_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final materialRepositoryProvider = Provider<IMaterialRepository>((ref) {
  final materialLocalDatasource = ref.read(materialLocalDatasourceProvider);
  final materialRemoteDatasource = ref.read(materialRemoteProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return MaterialRepositoryImpl(
    materialLocalDatasource: materialLocalDatasource,
    materialRemoteDatasource: materialRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class MaterialRepositoryImpl implements IMaterialRepository {
  final IMaterialDataSource _materialLocalDatasource;
  final IMaterialRemoteDataSource _materialRemoteDatasource;
  final NetworkInfo _networkInfo;

  MaterialRepositoryImpl({
    required IMaterialDataSource materialLocalDatasource,
    required IMaterialRemoteDataSource materialRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _materialLocalDatasource = materialLocalDatasource,
       _materialRemoteDatasource = materialRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> addMaterial(MaterialEntity material) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = MaterialModel.fromEntity(material);
        final result = await _materialRemoteDatasource.addMaterial(model);
        return Right(result);
      } on DioException catch (e) {
        return Left(Apifailure(message: e.message ?? 'Failed to add material'));
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      try {
        final model = MaterialModel.fromEntity(material);
        final result = await _materialLocalDatasource.addMaterial(model);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMaterial(String materialId) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _materialRemoteDatasource.deleteMaterial(
          materialId,
        );
        return Right(result);
      } on DioException catch (e) {
        return Left(
          Apifailure(message: e.message ?? 'Failed to delete material'),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _materialLocalDatasource.deleteMaterial(
          materialId,
        );
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<MaterialEntity>>> getAllMaterials() async {
    if (await _networkInfo.isConnected) {
      try {
        final materials = await _materialRemoteDatasource.getAllMaterials();
        return Right(MaterialModel.toEntityList(materials));
      } on DioException catch (e) {
        return Left(
          Apifailure(message: e.message ?? 'Failed to fetch materials'),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      try {
        final materials = await _materialLocalDatasource.getAllMaterials();
        return Right(MaterialModel.toEntityList(materials));
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, MaterialEntity>> getMaterialById(
    String materialId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final material = await _materialRemoteDatasource.getMaterialById(
          materialId,
        );
        if (material != null) {
          return Right(material.toEntity());
        }
        return Left(Apifailure(message: 'Material not found'));
      } on DioException catch (e) {
        return Left(
          Apifailure(message: e.message ?? 'Failed to fetch material'),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      try {
        final material = await _materialLocalDatasource.getMaterialById(
          materialId,
        );
        if (material != null) {
          return Right(material.toEntity());
        }
        return Left(LocalDatabaseFailure(messgae: 'Material not found'));
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<MaterialEntity>>> searchMaterials(
    String query,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final materials = await _materialRemoteDatasource.searchMaterials(
          query,
        );
        return Right(MaterialModel.toEntityList(materials));
      } on DioException catch (e) {
        return Left(
          Apifailure(message: e.message ?? 'Failed to search materials'),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      try {
        final materials = await _materialLocalDatasource.searchMaterials(query);
        return Right(MaterialModel.toEntityList(materials));
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> updateMaterial(MaterialEntity material) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = MaterialModel.fromEntity(material);
        final result = await _materialRemoteDatasource.updateMaterial(model);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          Apifailure(message: e.message ?? 'Failed to update material'),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      try {
        final model = MaterialModel.fromEntity(material);
        final result = await _materialLocalDatasource.updateMaterial(model);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }
}
