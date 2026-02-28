import 'package:businesstrack/features/low_stock_alert/data/models/low_stock_alert_model.dart';

abstract interface class ILowStockAlertRemoteDataSource {
  Future<List<LowStockAlertModel>> getAllAlerts();
  Future<List<LowStockAlertModel>> getUnresolvedAlerts();
  Future<LowStockAlertModel> getAlertById(String alertId);
  Future<bool> createAlert(LowStockAlertModel alert);
  Future<bool> resolveAlert(String alertId, String resolvedBy);
  Future<bool> deleteAlert(String alertId);
  Future<List<LowStockAlertModel>> checkLowStockItems();
}
