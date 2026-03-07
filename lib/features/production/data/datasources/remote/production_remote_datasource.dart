import 'package:businesstrack/core/api/api_client.dart';
import 'package:businesstrack/core/api/api_endpoints.dart';
import 'package:businesstrack/features/production/data/datasources/production_datasource.dart';
import 'package:businesstrack/features/production/data/models/production_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productionRemoteProvider = Provider<IProductionRemoteDataSource>((ref) {
  return ProductionRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class ProductionRemoteDatasource implements IProductionRemoteDataSource {
  final ApiClient _apiClient;

  ProductionRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<bool> startProduction(ProductionModel production) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.production,
        data: production.toJson(),
      );
      return response.data['success'] == true;
    } on DioException catch (e) {
      print('Start production error: $e');
      rethrow;
    }
  }

  Future<bool> completeProduction(
    String productionId, {
    double? actualOutput,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.productionComplete(productionId),
        data: {'actualOutput': actualOutput},
      );
      return response.data['success'] == true;
    } on DioException catch (e) {
      print('Complete production error: $e');
      rethrow;
    }
  }

  @override
  Future<List<ProductionModel>> getAllProduction() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.production);
      if (response.data['success'] == true) {
        final data = response.data['data'] as List;
        return data
            .map(
              (json) => ProductionModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }
      return [];
    } on DioException catch (e) {
      print('Get all production error: $e');
      rethrow;
    }
  }

  @override
  Future<ProductionModel?> getProductionById(String productionId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.productionById(productionId),
      );
      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        return ProductionModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      print('Get production by ID error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> deleteProduction(String productionId) async {
    try {
      final response = await _apiClient.delete(
        ApiEndpoints.productionDelete(productionId),
      );
      return response.data['success'] == true;
    } on DioException catch (e) {
      print('Delete production error: $e');
      rethrow;
    }
  }

  /// Old method for compatibility - renamed to completeProduction
  @override
  Future<bool> endProduction(
    String productionId, {
    double? actualOutput,
  }) async {
    return completeProduction(productionId, actualOutput: actualOutput);
  }

  /// Old method for compatibility
  @override
  Future<bool> updateProduction(ProductionModel production) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.productionById(production.productionId!),
        data: production.toJson(),
      );
      return response.data['success'] == true;
    } on DioException catch (e) {
      print('Update production error: $e');
      rethrow;
    }
  }
}
