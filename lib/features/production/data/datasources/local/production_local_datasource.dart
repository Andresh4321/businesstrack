import 'package:businesstrack/core/services/hive/Hive_Service.dart';
import 'package:businesstrack/features/production/data/datasources/production_datasource.dart';
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
      // TODO: Implement Hive service method
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
      // TODO: Implement Hive service method
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ProductionModel>> getAllProduction() async {
    try {
      // TODO: Implement Hive service method
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ProductionModel?> getProductionById(String productionId) async {
    try {
      // TODO: Implement Hive service method
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateProduction(ProductionModel production) async {
    try {
      // TODO: Implement Hive service method
      return true;
    } catch (e) {
      return false;
    }
  }
}
