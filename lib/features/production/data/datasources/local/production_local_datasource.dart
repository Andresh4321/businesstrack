import 'package:businesstrack/core/services/hive/Hive_Service.dart';
import 'package:businesstrack/features/production/data/datasources/production_datasource.dart';
import 'package:businesstrack/features/production/data/models/production_hive_model.dart';
import 'package:businesstrack/features/production/data/models/production_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productionLocalDatasourceProvider = Provider<ProductionLocalDatasource>((
  ref,
) {
  final hiveService = ref.read(hiveServiceProvider);
  return ProductionLocalDatasource(hiveService: hiveService);
});

class ProductionLocalDatasource implements IProductionDataSource {
  // ignore: unused_field
  final HiveService _hiveService;

  ProductionLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> startProduction(ProductionModel production) async {
    try {
      final hiveModel = ProductionHiveModel.fromEntity(production.toEntity());
      await _hiveService.createProduction(hiveModel);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> endProduction(
    String productionId, {
    double? actualOutput,
  }) async {
    try {
      final hiveModel = await _hiveService.getProductionById(productionId);
      if (hiveModel == null) return false;

      final entity = hiveModel.toEntity();
      final currentModel = ProductionModel.fromEntity(entity);

      final resolvedActualOutput =
          actualOutput ??
          currentModel.actualOutput ??
          currentModel.estimatedOutput;
      final estimated = currentModel.estimatedOutput;
      final wastage = estimated > 0
          ? ((estimated - resolvedActualOutput) / estimated * 100).clamp(
              0.0,
              100.0,
            )
          : 0.0;

      final updatedModel = ProductionModel(
        productionId: currentModel.productionId,
        recipeId: currentModel.recipeId,
        batchQuantity: currentModel.batchQuantity,
        estimatedOutput: currentModel.estimatedOutput,
        actualOutput: resolvedActualOutput,
        wastage: wastage,
        itemsUsed: currentModel.itemsUsed,
        status: 'completed',
        userId: currentModel.userId,
        createdAt: currentModel.createdAt,
        updatedAt: DateTime.now(),
      );

      final updatedHiveModel = ProductionHiveModel.fromEntity(
        updatedModel.toEntity(),
      );
      await _hiveService.updateProduction(updatedHiveModel);

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ProductionModel>> getAllProduction() async {
    try {
      final hiveModels = await _hiveService.getAllProductions();
      return hiveModels
          .map((hiveModel) => ProductionModel.fromEntity(hiveModel.toEntity()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ProductionModel?> getProductionById(String productionId) async {
    try {
      final hiveModel = await _hiveService.getProductionById(productionId);
      if (hiveModel == null) return null;
      return ProductionModel.fromEntity(hiveModel.toEntity());
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateProduction(ProductionModel production) async {
    try {
      final hiveModel = ProductionHiveModel.fromEntity(production.toEntity());
      await _hiveService.updateProduction(hiveModel);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteProduction(String productionId) async {
    try {
      await _hiveService.deleteProduction(productionId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
