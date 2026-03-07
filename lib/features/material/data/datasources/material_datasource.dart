import 'package:businesstrack/features/material/data/models/material_model.dart';

abstract interface class IMaterialDataSource {
  Future<List<MaterialModel>> getAllMaterials();
  Future<MaterialModel?> getMaterialById(String materialId);
  Future<bool> addMaterial(MaterialModel material);
  Future<bool> updateMaterial(MaterialModel material);
  Future<bool> deleteMaterial(String materialId);
  Future<List<MaterialModel>> searchMaterials(String query);
}

abstract interface class IMaterialLocalDataSource {
  Future<List<MaterialModel>> getAllMaterials();
  Future<MaterialModel?> getMaterialById(String materialId);
  Future<bool> addMaterial(MaterialModel material);
  Future<bool> updateMaterial(MaterialModel material);
  Future<bool> deleteMaterial(String materialId);
  Future<List<MaterialModel>> searchMaterials(String query);
}

abstract interface class IMaterialRemoteDataSource {
  Future<List<MaterialModel>> getAllMaterials();
  Future<MaterialModel?> getMaterialById(String materialId);
  Future<bool> addMaterial(MaterialModel material);
  Future<bool> updateMaterial(MaterialModel material);
  Future<bool> deleteMaterial(String materialId);
  Future<List<MaterialModel>> searchMaterials(String query);
}
