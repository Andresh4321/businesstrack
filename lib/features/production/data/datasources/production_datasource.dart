import 'package:businesstrack/features/production/data/models/production_model.dart';

abstract interface class IProductionDataSource {
  Future<List<ProductionModel>> getAllProduction();
  Future<ProductionModel?> getProductionById(String productionId);
  Future<bool> startProduction(ProductionModel production);
  Future<bool> updateProduction(ProductionModel production);
  Future<bool> endProduction(String productionId, {double? actualOutput});
  Future<bool> deleteProduction(String productionId);
}

abstract interface class IProductionLocalDataSource {
  Future<List<ProductionModel>> getAllProduction();
  Future<ProductionModel?> getProductionById(String productionId);
  Future<bool> startProduction(ProductionModel production);
  Future<bool> updateProduction(ProductionModel production);
  Future<bool> endProduction(String productionId, {double? actualOutput});
  Future<bool> deleteProduction(String productionId);
}

abstract interface class IProductionRemoteDataSource {
  Future<List<ProductionModel>> getAllProduction();
  Future<ProductionModel?> getProductionById(String productionId);
  Future<bool> startProduction(ProductionModel production);
  Future<bool> updateProduction(ProductionModel production);
  Future<bool> endProduction(String productionId, {double? actualOutput});
  Future<bool> deleteProduction(String productionId);
}
