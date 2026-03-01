import 'package:businesstrack/core/api/api_client.dart';
import 'package:businesstrack/core/api/api_endpoints.dart';
import 'package:businesstrack/features/supplier/data/datasource/ISupplierDataSource.dart';
import 'package:businesstrack/features/supplier/data/models/supplier_api_model.dart';
import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final supplierRemoteDatasourceProvider = Provider<SupplierRemoteDatasource>((
  ref,
) {
  return SupplierRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class SupplierRemoteDatasource implements ISupplierRemoteDataSource {
  final ApiClient _apiClient;

  SupplierRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<void> addSupplier(SupplierEntity entity, String userId) async {
    try {
      final model = SupplierApiModel.fromEntity(entity);
      await _apiClient.post(ApiEndpoints.suppliers, data: model.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SupplierEntity>> getSuppliers(String userId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.suppliers);

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data
          .map(
            (supplier) => SupplierApiModel.fromJson(
              supplier as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSupplier(String id, String userId) async {
    try {
      await _apiClient.delete(ApiEndpoints.supplierById(id));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateSupplier(SupplierEntity entity, String userId) async {
    try {
      final model = SupplierApiModel.fromEntity(entity);
      await _apiClient.put(
        ApiEndpoints.supplierById(entity.id!),
        data: model.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SupplierEntity>> searchSuppliersByName(
    String name,
    String userId,
  ) async {
    try {
      // Backend doesn't have search endpoint, filter locally
      final suppliers = await getSuppliers(userId);
      return suppliers
          .where((s) => s.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SupplierEntity>> searchSuppliersByProduct(
    String productName,
    String userId,
  ) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.suppliers}/search/product',
        queryParameters: {'product': productName, 'userId': userId},
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data
          .map(
            (supplier) => SupplierApiModel.fromJson(
              supplier as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
