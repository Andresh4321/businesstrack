import 'package:businesstrack/core/constants/hive_table_constant.dart';
import 'package:businesstrack/features/low_stock_alert/data/datasource/low_stock_alert_datasource.dart';
import 'package:businesstrack/features/low_stock_alert/data/models/low_stock_item_model.dart';
import 'package:hive/hive.dart';

class LowStockAlertLocalDataSource implements ILowStockAlertLocalDataSource {
  @override
  Future<List<LowStockItemModel>> getLowStockItems() async {
    try {
      final box = await Hive.openBox<LowStockItemModel>(
        HiveTableConstant.lowStockAlertBox,
      );
      return box.values.toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> saveLowStockItems(List<LowStockItemModel> items) async {
    try {
      final box = await Hive.openBox<LowStockItemModel>(
        HiveTableConstant.lowStockAlertBox,
      );
      await box.clear();
      await box.addAll(items);
      return true;
    } catch (e) {
      return false;
    }
  }
}
