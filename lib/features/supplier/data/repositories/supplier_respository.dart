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

  List<SupplierEntity> _sortByLatest(List<SupplierEntity> suppliers) {
    final sorted = List<SupplierEntity>.from(suppliers);
    sorted.sort((a, b) {
      final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
    return sorted;
  }

  @override
  Future<Either<Failure, void>> addSupplier(
    SupplierEntity entity,
    String userId,
  ) async {
    try {
      // Always save locally first so offline mode always works.
      await _localDatasource.addSupplier(entity, userId);

      // Best-effort remote sync if online.
      if (await _networkInfo.isConnected) {
        try {
          await _remoteDatasource.addSupplier(entity, userId);
        } catch (_) {}
      }

      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SupplierEntity>>> getSuppliers(
    String userId,
  ) async {
    try {
      final localSuppliers = await _localDatasource.getSuppliers(userId);

      if (localSuppliers.isNotEmpty || !(await _networkInfo.isConnected)) {
        return Right(_sortByLatest(localSuppliers));
      }

      final remoteSuppliers = await _remoteDatasource.getSuppliers(userId);
      for (final supplier in remoteSuppliers) {
        try {
          await _localDatasource.addSupplier(supplier, userId);
        } catch (_) {}
      }

      return Right(_sortByLatest(remoteSuppliers));
    } catch (e) {
      return Left(
        Apifailure(message: 'Failed to get suppliers: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteSupplier(String id, String userId) async {
    try {
      // Always delete local first.
      await _localDatasource.deleteSupplier(id, userId);

      // Best-effort remote delete.
      if (await _networkInfo.isConnected) {
        try {
          await _remoteDatasource.deleteSupplier(id, userId);
        } catch (_) {}
      }

      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSupplier(
    SupplierEntity entity,
    String userId,
  ) async {
    try {
      // Always update local first.
      await _localDatasource.updateSupplier(entity, userId);

      // Best-effort remote sync.
      if (await _networkInfo.isConnected) {
        try {
          await _remoteDatasource.updateSupplier(entity, userId);
        } catch (_) {}
      }

      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
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
