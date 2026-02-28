import 'package:businesstrack/core/constants/hive_table_constant.dart';
import 'package:businesstrack/features/low_stock_alert/data/datasources/low_stock_alert_datasource.dart';
import 'package:businesstrack/features/low_stock_alert/data/models/low_stock_alert_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final lowStockAlertLocalDatasourceProvider = Provider<ILowStockAlertDataSource>(
  (ref) {
    return LowStockAlertLocalDataSource();
  },
);

class LowStockAlertLocalDataSource implements ILowStockAlertDataSource {
  LowStockAlertLocalDataSource();

  Box<LowStockAlertModel> get _alertBox =>
      Hive.box<LowStockAlertModel>(HiveTableConstant.lowStockAlertBox);

  @override
  Future<List<LowStockAlertModel>> getAllAlerts() async {
    try {
      final alerts = _alertBox.values.toList();
      return alerts;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<LowStockAlertModel>> getUnresolvedAlerts() async {
    try {
      final alerts = _alertBox.values
          .where((alert) => !alert.isResolved)
          .toList();
      return alerts;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LowStockAlertModel> getAlertById(String alertId) async {
    try {
      final alert = _alertBox.values.firstWhere(
        (alert) => alert.alertId == alertId,
      );
      return alert;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> saveAlert(LowStockAlertModel alert) async {
    try {
      await _alertBox.put(alert.alertId, alert);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateAlert(LowStockAlertModel alert) async {
    try {
      await _alertBox.put(alert.alertId, alert);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteAlert(String alertId) async {
    try {
      await _alertBox.delete(alertId);
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
