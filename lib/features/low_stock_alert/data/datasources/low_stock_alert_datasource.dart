import 'package:businesstrack/features/low_stock_alert/data/models/low_stock_alert_model.dart';

abstract interface class ILowStockAlertDataSource {
  Future<List<LowStockAlertModel>> getAllAlerts();
  Future<List<LowStockAlertModel>> getUnresolvedAlerts();
  Future<LowStockAlertModel> getAlertById(String alertId);
  Future<bool> saveAlert(LowStockAlertModel alert);
  Future<bool> deleteAlert(String alertId);
  Future<bool> updateAlert(LowStockAlertModel alert);
}
