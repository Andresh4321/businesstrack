import 'package:businesstrack/core/api/api_client.dart';
import 'package:businesstrack/core/api/api_endpoints.dart';
import 'package:businesstrack/features/stock/data/datasources/stock_datasource.dart';
import 'package:businesstrack/features/stock/data/models/stock_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stockRemoteProvider = Provider<IStockRemoteDataSource>((ref) {
  return StockRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class StockRemoteDatasource implements IStockRemoteDataSource {
  final ApiClient _apiClient;

  StockRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<bool> addStock(StockModel stock) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.stock,
        data: stock.toJson(),
      );
      return response.data['success'] == true;
    } on DioException catch (e) {
      print('Add stock error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> deleteStock(String stockId) async {
    try {
      final response = await _apiClient.delete(ApiEndpoints.stockById(stockId));
      return response.data['success'] == true;
    } on DioException catch (e) {
      print('Delete stock error: $e');
      rethrow;
    }
  }

  @override
  Future<List<StockModel>> getAllStock() async {
    try {
      print('📥 [StockRemote] Fetching all stock transactions...');
      final response = await _apiClient.get(ApiEndpoints.stock);
      print('📥 [StockRemote] Response status: ${response.statusCode}');
      print('📥 [StockRemote] Response success: ${response.data['success']}');
      print(
        '📥 [StockRemote] Response data type: ${response.data['data'].runtimeType}',
      );

      if (response.data['success'] == true) {
        final rawData = response.data['data'];
        final data = rawData is List
            ? rawData
            : rawData is Map
            ? (rawData['stockTransactions'] as List?) ??
                  (rawData['transactions'] as List?) ??
                  []
            : [];

        print('📥 [StockRemote] Data array length: ${data.length}');
        if (data.isNotEmpty) {
          print(
            '📥 [StockRemote] First item keys: ${(data[0] as Map).keys.toList()}',
          );
          print('📥 [StockRemote] First item sample: ${data[0]}');
        }

        final parsed = <StockModel>[];

        for (final row in data) {
          if (row is! Map) {
            print('⚠️ [StockRemote] Skipping non-map row: ${row.runtimeType}');
            continue;
          }

          try {
            final model = StockModel.fromJson(Map<String, dynamic>.from(row));
            parsed.add(model);
            print(
              '✅ [StockRemote] Parsed transaction: ${model.stockId}, material: ${model.materialId}, type: ${model.transactionType}',
            );
          } catch (e, stack) {
            print('❌ [StockRemote] Failed to parse row: $e');
            print('❌ [StockRemote] Row data: $row');
            print(
              '❌ [StockRemote] Stack: ${stack.toString().split('\n').take(3).join('\n')}',
            );
          }
        }

        print(
          '📥 [StockRemote] Successfully parsed ${parsed.length} transactions',
        );
        return parsed;
      }
      print('⚠️ [StockRemote] API returned success=false');
      return [];
    } on DioException catch (e) {
      print('❌ [StockRemote] Get all stock error: $e');
      print('❌ [StockRemote] Response: ${e.response?.data}');
      rethrow;
    }
  }

  /// Get current stock levels (aggregated)
  Future<List<Map<String, dynamic>>> getCurrentStock() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.stockCurrent);
      if (response.data['success'] == true) {
        final data = response.data['data'] as List;
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } on DioException catch (e) {
      print('Get current stock error: $e');
      rethrow;
    }
  }

  @override
  Future<StockModel?> getStockById(String stockId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.stockById(stockId));
      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        return StockModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      print('Get stock by ID error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> updateStock(StockModel stock) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.stockById(stock.stockId!),
        data: stock.toJson(),
      );
      return response.data['success'] == true;
    } on DioException catch (e) {
      print('Update stock error: $e');
      rethrow;
    }
  }

  Future<bool> createStockTransaction({
    required String materialId,
    required double quantity,
    required String transactionType,
    String? description,
  }) async {
    try {
      print('📤 [StockRemote] Creating stock transaction...');
      print(
        '📤 [StockRemote] Material: $materialId, Qty: $quantity, Type: $transactionType',
      );

      final response = await _apiClient.post(
        ApiEndpoints.stock,
        data: {
          'material': materialId,
          'quantity': quantity,
          'transaction_type': transactionType,
          if (description != null) 'description': description,
        },
      );

      print('✅ [StockRemote] Response: ${response.statusCode}');
      return response.data['success'] == true;
    } on DioException catch (e) {
      print('❌ [StockRemote] Create transaction error:');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');
      rethrow;
    }
  }
}
