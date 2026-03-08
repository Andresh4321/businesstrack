import 'package:businesstrack/core/services/hive/Hive_Service.dart';
import 'package:businesstrack/features/stock/data/datasources/stock_datasource.dart';
import 'package:businesstrack/features/stock/data/models/stock_model.dart';
import 'package:businesstrack/features/stock/data/models/stock_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stockLocalDatasourceProvider = Provider<StockLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return StockLocalDatasource(hiveService: hiveService);
});

class StockLocalDatasource implements IStockDataSource {
  final HiveService _hiveService;

  StockLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> addStock(StockModel stock) async {
    try {
      final hiveModel = StockHiveModel.fromEntity(stock.toEntity());
      await _hiveService.createStock(hiveModel);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteStock(String stockId) async {
    try {
      await _hiveService.deleteStock(stockId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<StockModel>> getAllStock() async {
    try {
      final hiveModels = _hiveService.getAllStock();
      return hiveModels
          .map((hiveModel) => StockModel.fromEntity(hiveModel.toEntity()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<StockModel?> getStockById(String stockId) async {
    try {
      final hiveModel = await _hiveService.getStockById(stockId);
      if (hiveModel == null) return null;
      return StockModel.fromEntity(hiveModel.toEntity());
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateStock(StockModel stock) async {
    try {
      final hiveModel = StockHiveModel.fromEntity(stock.toEntity());
      await _hiveService.updateStock(hiveModel);
      return true;
    } catch (e) {
      return false;
    }
  }
}
