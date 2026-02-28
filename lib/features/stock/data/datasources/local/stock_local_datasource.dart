import 'package:businesstrack/core/services/hive/Hive_Service.dart';
import 'package:businesstrack/features/stock/data/datasources/stock_datasource.dart';
import 'package:businesstrack/features/stock/data/models/stock_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stockLocalDatasourceProvider = Provider<StockLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return StockLocalDatasource(hiveService: hiveService);
});

class StockLocalDatasource implements IStockDataSource {
  // ignore: unused_field
  final HiveService _hiveService;

  StockLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> addStock(StockModel stock) async {
    try {
      // TODO: Implement Hive service method
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteStock(String stockId) async {
    try {
      // TODO: Implement Hive service method
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<StockModel>> getAllStock() async {
    try {
      // TODO: Implement Hive service method
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<StockModel?> getStockById(String stockId) async {
    try {
      // TODO: Implement Hive service method
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateStock(StockModel stock) async {
    try {
      // TODO: Implement Hive service method
      return true;
    } catch (e) {
      return false;
    }
  }
}
