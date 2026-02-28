import 'package:businesstrack/core/api/api_client.dart';
import 'package:businesstrack/core/api/api_endpoints.dart';
import 'package:businesstrack/features/bill_of_materials/data/datasource/bill_of_materials_datasource.dart';
import 'package:businesstrack/features/bill_of_materials/data/models/bill_of_materials_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final billOfMaterialsRemoteProvider =
    Provider<IBillOfMaterialsRemoteDataSource>((ref) {
      return BillOfMaterialsRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
      );
    });

class BillOfMaterialsRemoteDatasource
    implements IBillOfMaterialsRemoteDataSource {
  final ApiClient _apiClient;

  BillOfMaterialsRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<BillOfMaterialsModel>> getAllBillItems() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.billOfMaterials);
      if (response.data['success'] == true) {
        final data = response.data['data'] as List;
        return data
            .map(
              (json) =>
                  BillOfMaterialsModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }
      return [];
    } on DioException catch (e) {
      print('Get all bill items error: $e');
      rethrow;
    }
  }

  @override
  Future<BillOfMaterialsModel> createBillItem(
    BillOfMaterialsModel model,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.billOfMaterials,
        data: model.toJson(),
      );
      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        return BillOfMaterialsModel.fromJson(data);
      }
      return model;
    } on DioException catch (e) {
      print('Create bill item error: $e');
      rethrow;
    }
  }

  @override
  Future<BillOfMaterialsModel> updatePrice(String billId, double price) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.billOfMaterialsChangePrice(billId),
        data: {'price': price},
      );
      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        return BillOfMaterialsModel.fromJson(data);
      }
      throw Exception('Failed to update price');
    } on DioException catch (e) {
      print('Update price error: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteBillItem(String billId) async {
    try {
      await _apiClient.delete(ApiEndpoints.billOfMaterialsById(billId));
    } on DioException catch (e) {
      print('Delete bill item error: $e');
      rethrow;
    }
  }

  @override
  Future<BillOfMaterialsModel?> getBillItemById(String billId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.billOfMaterialsById(billId),
      );
      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        return BillOfMaterialsModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      print('Get bill item by ID error: $e');
      rethrow;
    }
  }
}
