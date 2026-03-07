import 'package:businesstrack/features/stock/data/models/stock_model.dart';

abstract interface class IStockDataSource {
  Future<List<StockModel>> getAllStock();
  Future<StockModel?> getStockById(String stockId);
  Future<bool> updateStock(StockModel stock);
  Future<bool> addStock(StockModel stock);
  Future<bool> deleteStock(String stockId);
}

abstract interface class IStockLocalDataSource {
  Future<List<StockModel>> getAllStock();
  Future<StockModel?> getStockById(String stockId);
  Future<bool> updateStock(StockModel stock);
  Future<bool> addStock(StockModel stock);
  Future<bool> deleteStock(String stockId);
}

abstract interface class IStockRemoteDataSource {
  Future<List<StockModel>> getAllStock();
  Future<StockModel?> getStockById(String stockId);
  Future<bool> updateStock(StockModel stock);
  Future<bool> addStock(StockModel stock);
  Future<bool> deleteStock(String stockId);
  Future<bool> createStockTransaction({
    required String materialId,
    required double quantity,
    required String transactionType,
    String? description,
  });
}
