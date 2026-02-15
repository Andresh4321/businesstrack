import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/services/connectivity/network_info.dart';
import 'package:businesstrack/features/supplier/data/datasource/ISupplierDataSource.dart';
import 'package:businesstrack/features/supplier/data/datasource/local/supplier_local_datasource.dart';
import 'package:businesstrack/features/supplier/data/datasource/remote/supplieremotedatasource.dart';
import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';
import 'package:businesstrack/features/supplier/domain/repository/supplier_respository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final supplierRepositoryProvider = Provider<ISupplierRepository>((ref) {
  final localDatasource = ref.read(supplierLocalDatasourceProvider);
  final remoteDatasource = ref.read(supplierRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return SupplierRepository(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class SupplierRepository implements ISupplierRepository {
  final ISupplierDataSource _localDatasource;
  final ISupplierRemoteDataSource _remoteDatasource;
  final NetworkInfo _networkInfo;

  SupplierRepository({
    required ISupplierDataSource localDatasource,
    required ISupplierRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _localDatasource = localDatasource,
       _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, void>> addSupplier(
    SupplierEntity entity,
    String userId,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        // Try remote first
        await _remoteDatasource.addSupplier(entity, userId);
      }
      // Always save to local
      await _localDatasource.addSupplier(entity, userId);
      return const Right(null);
    } catch (e) {
      return Left(
        Apifailure(message: 'Failed to add supplier: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<SupplierEntity>>> getSuppliers(
    String userId,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        // Fetch from remote and update local
        final remoteSuppliers = await _remoteDatasource.getSuppliers(userId);
        // Update local cache
        for (var supplier in remoteSuppliers) {
          await _localDatasource.updateSupplier(supplier, userId);
        }
        return Right(remoteSuppliers);
      }
      // Fall back to local
      final localSuppliers = await _localDatasource.getSuppliers(userId);
      return Right(localSuppliers);
    } catch (e) {
      // Try local as fallback
      try {
        final localSuppliers = await _localDatasource.getSuppliers(userId);
        return Right(localSuppliers);
      } catch (_) {
        return Left(
          Apifailure(message: 'Failed to get suppliers: ${e.toString()}'),
        );
      }
    }
  }

  @override
  Future<Either<Failure, void>> deleteSupplier(String id, String userId) async {
    try {
      if (await _networkInfo.isConnected) {
        // Try remote first
        await _remoteDatasource.deleteSupplier(id, userId);
      }
      // Always delete from local
      await _localDatasource.deleteSupplier(id, userId);
      return const Right(null);
    } catch (e) {
      return Left(
        Apifailure(message: 'Failed to delete supplier: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateSupplier(
    SupplierEntity entity,
    String userId,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        // Try remote first
        await _remoteDatasource.updateSupplier(entity, userId);
      }
      // Always update local
      await _localDatasource.updateSupplier(entity, userId);
      return const Right(null);
    } catch (e) {
      return Left(
        Apifailure(message: 'Failed to update supplier: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<SupplierEntity>>> searchSuppliersByName(
    String name,
    String userId,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        final results = await _remoteDatasource.searchSuppliersByName(
          name,
          userId,
        );
        return Right(results);
      }
      final results = await _localDatasource.searchSuppliersByName(
        name,
        userId,
      );
      return Right(results);
    } catch (e) {
      try {
        final results = await _localDatasource.searchSuppliersByName(
          name,
          userId,
        );
        return Right(results);
      } catch (_) {
        return Left(
          Apifailure(
            message: 'Failed to search suppliers by name: ${e.toString()}',
          ),
        );
      }
    }
  }

  @override
  Future<Either<Failure, List<SupplierEntity>>> searchSuppliersByProduct(
    String productName,
    String userId,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        final results = await _remoteDatasource.searchSuppliersByProduct(
          productName,
          userId,
        );
        return Right(results);
      }
      final results = await _localDatasource.searchSuppliersByProduct(
        productName,
        userId,
      );
      return Right(results);
    } catch (e) {
      try {
        final results = await _localDatasource.searchSuppliersByProduct(
          productName,
          userId,
        );
        return Right(results);
      } catch (_) {
        return Left(
          Apifailure(
            message: 'Failed to search suppliers by product: ${e.toString()}',
          ),
        );
      }
    }
  }
}
