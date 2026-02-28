import 'package:businesstrack/features/low_stock_alert/data/models/low_stock_item_model.dart';

abstract interface class ILowStockAlertDataSource {
  Future<List<LowStockItemModel>> getLowStockItems();
  Future<List<LowStockItemModel>> getCriticalStockItems();
}

abstract interface class ILowStockAlertRemoteDataSource {
  Future<List<LowStockItemModel>> getLowStockItems();
  Future<List<LowStockItemModel>> getCriticalStockItems();
}

abstract interface class ILowStockAlertLocalDataSource {
  Future<List<LowStockItemModel>> getLowStockItems();
  Future<bool> saveLowStockItems(List<LowStockItemModel> items);
}
