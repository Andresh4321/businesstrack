import 'package:businesstrack/core/services/hive/Hive_Service.dart';
import 'package:businesstrack/features/recipe/data/datasources/recipe_datasource.dart';
import 'package:businesstrack/features/recipe/data/models/recipe_model.dart';
import 'package:businesstrack/features/recipe/data/models/recipe_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipeLocalDatasourceProvider = Provider<RecipeLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return RecipeLocalDatasource(hiveService: hiveService);
});

class RecipeLocalDatasource implements IRecipeDataSource {
  final HiveService _hiveService;

  RecipeLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> createRecipe(RecipeModel recipe) async {
    try {
      final hiveModel = RecipeHiveModel.fromEntity(recipe.toEntity());
      await _hiveService.createRecipe(hiveModel);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteRecipe(String recipeId) async {
    try {
      await _hiveService.deleteRecipe(recipeId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<RecipeModel>> getAllRecipes() async {
    try {
      final hiveModels = _hiveService.getAllRecipes();
      return hiveModels
          .map((hiveModel) => RecipeModel.fromEntity(hiveModel.toEntity()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<RecipeModel?> getRecipeById(String recipeId) async {
    try {
      final hiveModel = await _hiveService.getRecipeById(recipeId);
      if (hiveModel == null) return null;
      return RecipeModel.fromEntity(hiveModel.toEntity());
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateRecipe(RecipeModel recipe) async {
    try {
      final hiveModel = RecipeHiveModel.fromEntity(recipe.toEntity());
      await _hiveService.updateRecipe(hiveModel);
      return true;
    } catch (e) {
      return false;
    }
  }
}
