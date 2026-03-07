import 'package:businesstrack/core/api/api_client.dart';
import 'package:businesstrack/core/api/api_endpoints.dart';
import 'package:businesstrack/features/material/data/datasources/material_datasource.dart';
import 'package:businesstrack/features/material/data/models/material_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final materialRemoteProvider = Provider<IMaterialRemoteDataSource>((ref) {
  return MaterialRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class MaterialRemoteDatasource implements IMaterialRemoteDataSource {
  final ApiClient _apiClient;

  MaterialRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  List<MaterialModel> _parseMaterialsResponse(Response response) {
    final data = response.data;

    // Supported shapes:
    // 1) { success: true, data: [ ... ] }
    // 2) { data: [ ... ] }
    // 3) [ ... ]
    final dynamic rawList;
    if (data is List) {
      rawList = data;
    } else if (data is Map<String, dynamic>) {
      final success = data['success'];
      if (success == false) {
        return [];
      }
      rawList = data['data'] ?? data['materials'] ?? [];
    } else {
      return [];
    }

    if (rawList is! List) {
      return [];
    }

    return rawList
        .whereType<Map>()
        .map((json) => MaterialModel.fromJson(json.cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<bool> addMaterial(MaterialModel material) async {
    try {
      print('📤 [MaterialRemote] Sending add material request...');
      print('📤 [MaterialRemote] Data: ${material.toJson()}');

      final payload = {
        ...material.toJson(),
        // Ensure backend always receives a quantity value; default to 0.
        'quantity': material.quantity,
      };

      final response = await _apiClient.post(
        ApiEndpoints.materialCreate,
        data: payload,
      );

      print('✅ [MaterialRemote] Response: ${response.statusCode}');
      print('✅ [MaterialRemote] Response data: ${response.data}');

      return response.data['success'] == true;
    } on DioException catch (e) {
      print('❌ [MaterialRemote] Add material error:');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');
      print('❌ Error Type: ${e.type}');
      print('❌ Error Message: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<bool> deleteMaterial(String materialId) async {
    try {
      final response = await _apiClient.delete(
        ApiEndpoints.materialDelete(materialId),
      );
      return response.data['success'] == true;
    } on DioException catch (e) {
      print('Delete material error: $e');
      rethrow;
    }
  }

  @override
  Future<List<MaterialModel>> getAllMaterials() async {
    try {
      // Some backends default to paginated results (e.g., limit=10).
      // First try requesting a large limit; if unsupported, fall back.
      try {
        final response = await _apiClient.get(
          ApiEndpoints.materials,
          queryParameters: const {'page': 1, 'limit': 1000},
        );
        return _parseMaterialsResponse(response);
      } on DioException {
        final fallbackResponse = await _apiClient.get(ApiEndpoints.materials);
        return _parseMaterialsResponse(fallbackResponse);
      }
    } on DioException catch (e) {
      print('Get all materials error: $e');
      rethrow;
    }
  }

  @override
  Future<MaterialModel?> getMaterialById(String materialId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.materialById(materialId),
      );
      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        return MaterialModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      print('Get material by ID error: $e');
      rethrow;
    }
  }

  @override
  Future<List<MaterialModel>> searchMaterials(String query) async {
    // Backend doesn't have search endpoint, filter locally
    final materials = await getAllMaterials();
    return materials
        .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<bool> updateMaterial(MaterialModel material) async {
    try {
      final payload = Map<String, dynamic>.from(material.toJson());
      // Stock updates are handled via stock transactions, so avoid sending quantity here.
      payload.remove('quantity');

      final response = await _apiClient.put(
        ApiEndpoints.materialUpdate(material.materialId!),
        data: payload,
      );
      return response.data['success'] == true;
    } on DioException catch (e) {
      print('Update material error: $e');
      rethrow;
    }
  }
}
