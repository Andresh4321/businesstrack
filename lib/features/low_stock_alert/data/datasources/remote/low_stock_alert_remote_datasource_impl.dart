import 'package:businesstrack/core/api/api_client.dart';
import 'package:businesstrack/features/low_stock_alert/data/datasources/remote/low_stock_alert_remote_datasource.dart';
import 'package:businesstrack/features/low_stock_alert/data/models/low_stock_alert_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lowStockAlertRemoteProvider = Provider<ILowStockAlertRemoteDataSource>((
  ref,
) {
  final apiService = ref.read(apiClientProvider);
  return LowStockAlertRemoteDataSource(apiService: apiService);
});

class LowStockAlertRemoteDataSource implements ILowStockAlertRemoteDataSource {
  final ApiClient _apiService;

  LowStockAlertRemoteDataSource({required ApiClient apiService})
    : _apiService = apiService;

  @override
  Future<List<LowStockAlertModel>> getAllAlerts() async {
    try {
      final response = await _apiService.get('/low-stock-alerts');

      final alerts = (response.data as List)
          .map((json) => LowStockAlertModel.fromJson(json))
          .toList();

      return alerts;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<LowStockAlertModel>> getUnresolvedAlerts() async {
    try {
      final response = await _apiService.get('/low-stock-alerts/unresolved');

      final alerts = (response.data as List)
          .map((json) => LowStockAlertModel.fromJson(json))
          .toList();

      return alerts;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LowStockAlertModel> getAlertById(String alertId) async {
    try {
      final response = await _apiService.get('/low-stock-alerts/$alertId');

      return LowStockAlertModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> createAlert(LowStockAlertModel alert) async {
    try {
      await _apiService.post('/low-stock-alerts', data: alert.toJson());

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> resolveAlert(String alertId, String resolvedBy) async {
    try {
      await _apiService.dio.patch(
        '/low-stock-alerts/$alertId/resolve',
        data: {'resolvedBy': resolvedBy},
      );

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteAlert(String alertId) async {
    try {
      await _apiService.delete('/low-stock-alerts/$alertId');

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<LowStockAlertModel>> checkLowStockItems() async {
    try {
      final response = await _apiService.get('/low-stock-alerts/check');

      final alerts = (response.data as List)
          .map((json) => LowStockAlertModel.fromJson(json))
          .toList();

      return alerts;
    } catch (e) {
      rethrow;
    }
  }
}
