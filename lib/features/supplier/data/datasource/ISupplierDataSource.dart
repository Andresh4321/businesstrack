import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';

abstract interface class ISupplierDataSource {
  Future<void> addSupplier(SupplierEntity entity, String userId);
  Future<List<SupplierEntity>> getSuppliers(String userId);
  Future<void> deleteSupplier(String id, String userId);
  Future<void> updateSupplier(SupplierEntity entity, String userId);
  Future<List<SupplierEntity>> searchSuppliersByName(
    String name,
    String userId,
  );
  Future<List<SupplierEntity>> searchSuppliersByProduct(
    String productName,
    String userId,
  );
}

abstract interface class ISupplierRemoteDataSource {
  Future<void> addSupplier(SupplierEntity entity, String userId);
  Future<List<SupplierEntity>> getSuppliers(String userId);
  Future<void> deleteSupplier(String id, String userId);
  Future<void> updateSupplier(SupplierEntity entity, String userId);
  Future<List<SupplierEntity>> searchSuppliersByName(
    String name,
    String userId,
    String? lastId,
  );
  Future<List<SupplierEntity>> searchSuppliersByProduct(
    String productName,
    String userId,
  );
}
