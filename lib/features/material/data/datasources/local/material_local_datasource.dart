import 'package:businesstrack/core/services/hive/Hive_Service.dart';
import 'package:businesstrack/features/material/data/datasources/material_datasource.dart';
import 'package:businesstrack/features/material/data/models/material_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final materialLocalDatasourceProvider = Provider<MaterialLocalDatasource>((
  ref,
) {
  final hiveService = ref.read(hiveServiceProvider);
  return MaterialLocalDatasource(hiveService: hiveService);
});

class MaterialLocalDatasource implements IMaterialDataSource {
  // ignore: unused_field
  final HiveService _hiveService;

  MaterialLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> addMaterial(MaterialModel material) async {
    try {
      // TODO: Implement Hive service method
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteMaterial(String materialId) async {
    try {
      // TODO: Implement Hive service method
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<MaterialModel>> getAllMaterials() async {
    try {
      // TODO: Implement Hive service method
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<MaterialModel?> getMaterialById(String materialId) async {
    try {
      // TODO: Implement Hive service method
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<MaterialModel>> searchMaterials(String query) async {
    try {
      // TODO: Implement Hive service method
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> updateMaterial(MaterialModel material) async {
    try {
      // TODO: Implement Hive service method
      return true;
    } catch (e) {
      return false;
    }
  }
}
