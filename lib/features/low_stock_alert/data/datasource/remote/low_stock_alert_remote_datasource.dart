import 'package:businesstrack/core/api/api_client.dart';
import 'package:businesstrack/core/api/api_endpoints.dart';
import 'package:businesstrack/features/low_stock_alert/data/datasource/low_stock_alert_datasource.dart';
import 'package:businesstrack/features/low_stock_alert/data/models/low_stock_item_model.dart';
import 'package:dio/dio.dart';

class LowStockAlertRemoteDataSource implements ILowStockAlertRemoteDataSource {
  final ApiClient apiClient;

  LowStockAlertRemoteDataSource({required this.apiClient});

  @override
  Future<List<LowStockItemModel>> getLowStockItems() async {
    try {
      // Get current stock levels from backend
      final response = await apiClient.get(ApiEndpoints.stockCurrent);
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final stockList = data['data'] as List<dynamic>;
        
        // Convert to models and filter for low stock
        final allStockItems = stockList
            .map((json) => LowStockItemModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        // Filter items where current quantity is below minimum stock
        return allStockItems
            .where((item) => item.currentQuantity < item.minimumStock)
            .toList();
      }
      
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Failed to fetch low stock items',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<LowStockItemModel>> getCriticalStockItems() async {
    try {
      // Get all low stock items first
      final lowStockItems = await getLowStockItems();
      
      // Filter for critical items (below 25% of minimum stock)
      return lowStockItems
          .where((item) => item.currentQuantity < (item.minimumStock * 0.25))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
