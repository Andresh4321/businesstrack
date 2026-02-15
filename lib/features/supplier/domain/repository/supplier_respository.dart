import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class ISupplierRepository {
  Future<Either<Failure, void>> addSupplier(
    SupplierEntity entity,
    String userId,
  );
  Future<Either<Failure, List<SupplierEntity>>> getSuppliers(String userId);
  Future<Either<Failure, void>> deleteSupplier(String id, String userId);
  Future<Either<Failure, void>> updateSupplier(
    SupplierEntity entity,
    String userId,
  );
  Future<Either<Failure, List<SupplierEntity>>> searchSuppliersByName(
    String name,
    String userId,
  );
  Future<Either<Failure, List<SupplierEntity>>> searchSuppliersByProduct(
    String productName,
    String userId,
  );
}
