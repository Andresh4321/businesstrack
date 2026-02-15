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
      final response = await _apiClient.get(
        ApiEndpoints.suppliers,
        queryParameters: {'userId': userId},
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return (data as List)
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
      await _apiClient.delete(
        ApiEndpoints.suppliers,
        queryParameters: {'id': id, 'userId': userId},
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateSupplier(SupplierEntity entity, String userId) async {
    try {
      final model = SupplierApiModel.fromEntity(entity);
      await _apiClient.put(
        '${ApiEndpoints.suppliers}/${entity.id}',
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
      final response = await _apiClient.get(
        '${ApiEndpoints.suppliers}/search',
        queryParameters: {'name': name, 'userId': userId},
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return (data as List)
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
      return (data as List)
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
