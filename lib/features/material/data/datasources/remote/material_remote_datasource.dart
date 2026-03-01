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

  @override
  Future<bool> addMaterial(MaterialModel material) async {
    try {
      print('📤 [MaterialRemote] Sending add material request...');
      print('📤 [MaterialRemote] Data: ${material.toJson()}');

      final response = await _apiClient.post(
        ApiEndpoints.materials,
        data: material.toJson(),
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
        ApiEndpoints.materialById(materialId),
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
      final response = await _apiClient.get(ApiEndpoints.materials);
      if (response.data['success'] == true) {
        final data = response.data['data'] as List;
        return data
            .map((json) => MaterialModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
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
      final response = await _apiClient.put(
        ApiEndpoints.materialById(material.materialId!),
        data: material.toJson(),
      );
      return response.data['success'] == true;
    } on DioException catch (e) {
      print('Update material error: $e');
      rethrow;
    }
  }
}
