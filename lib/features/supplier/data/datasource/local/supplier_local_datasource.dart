import 'package:businesstrack/core/services/hive/Hive_Service.dart';
import 'package:businesstrack/features/supplier/data/datasource/ISupplierDataSource.dart';
import 'package:businesstrack/features/supplier/data/models/supplier_hive_model.dart';
import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final supplierLocalDatasourceProvider = Provider<SupplierLocalDatasource>((
  ref,
) {
  return SupplierLocalDatasource(hiveService: ref.read(hiveServiceProvider));
});

class SupplierLocalDatasource implements ISupplierDataSource {
  final HiveService _hiveService;

  SupplierLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<void> addSupplier(SupplierEntity entity, String userId) async {
    final hiveModel = SupplierHiveModel.fromEntity(entity);
    await _hiveService.createSupplier(hiveModel, userId);
  }

  @override
  Future<List<SupplierEntity>> getSuppliers(String userId) async {
    final suppliers = _hiveService.getSuppliersByUserId(userId);
    return SupplierHiveModel.toEntityList(suppliers);
  }

  @override
  Future<void> deleteSupplier(String id, String userId) async {
    await _hiveService.deleteSupplier(id, userId);
  }

  @override
  Future<void> updateSupplier(SupplierEntity entity, String userId) async {
    final hiveModel = SupplierHiveModel.fromEntity(entity);
    await _hiveService.updateSupplier(hiveModel, userId);
  }

  @override
  Future<List<SupplierEntity>> searchSuppliersByName(
    String name,
    String userId,
  ) async {
    final suppliers = _hiveService.getSuppliersByUserId(userId);
    final filtered = suppliers
        .where(
          (supplier) =>
              supplier.name.toLowerCase().contains(name.toLowerCase()),
        )
        .toList();
    return SupplierHiveModel.toEntityList(filtered);
  }

  @override
  Future<List<SupplierEntity>> searchSuppliersByProduct(
    String productName,
    String userId,
  ) async {
    final suppliers = _hiveService.getSuppliersByUserId(userId);
    final filtered = suppliers
        .where(
          (supplier) => supplier.productNames.any(
            (product) =>
                product.toLowerCase().contains(productName.toLowerCase()),
          ),
        )
        .toList();
    return SupplierHiveModel.toEntityList(filtered);
  }
}
