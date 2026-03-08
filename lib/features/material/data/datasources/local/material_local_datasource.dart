import 'package:businesstrack/core/services/hive/Hive_Service.dart';
import 'package:businesstrack/features/material/data/datasources/material_datasource.dart';
import 'package:businesstrack/features/material/data/models/material_model.dart';
import 'package:businesstrack/features/material/data/models/material_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final materialLocalDatasourceProvider = Provider<MaterialLocalDatasource>((
  ref,
) {
  final hiveService = ref.read(hiveServiceProvider);
  return MaterialLocalDatasource(hiveService: hiveService);
});

class MaterialLocalDatasource implements IMaterialDataSource {
  final HiveService _hiveService;

  MaterialLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> addMaterial(MaterialModel material) async {
    try {
      final hiveModel = MaterialHiveModel.fromEntity(material.toEntity());
      await _hiveService.createMaterial(hiveModel);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteMaterial(String materialId) async {
    try {
      await _hiveService.deleteMaterial(materialId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<MaterialModel>> getAllMaterials() async {
    try {
      final hiveModels = _hiveService.getAllMaterials();
      return hiveModels
          .map((hiveModel) => MaterialModel.fromEntity(hiveModel.toEntity()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<MaterialModel?> getMaterialById(String materialId) async {
    try {
      final hiveModel = await _hiveService.getMaterialById(materialId);
      if (hiveModel == null) return null;
      return MaterialModel.fromEntity(hiveModel.toEntity());
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<MaterialModel>> searchMaterials(String query) async {
    try {
      final allMaterials = _hiveService.getAllMaterials();
      final filtered = allMaterials.where((material) {
        final name = material.name.toLowerCase();
        final description = material.description?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery) || description.contains(searchQuery);
      }).toList();
      return filtered
          .map((hiveModel) => MaterialModel.fromEntity(hiveModel.toEntity()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> updateMaterial(MaterialModel material) async {
    try {
      final hiveModel = MaterialHiveModel.fromEntity(material.toEntity());
      await _hiveService.updateMaterial(hiveModel);
      return true;
    } catch (e) {
      return false;
    }
  }
}
