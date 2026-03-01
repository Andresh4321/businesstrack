import 'package:businesstrack/core/services/hive/Hive_Service.dart';
import 'package:businesstrack/features/recipe/data/datasources/recipe_datasource.dart';
import 'package:businesstrack/features/recipe/data/models/recipe_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipeLocalDatasourceProvider = Provider<RecipeLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return RecipeLocalDatasource(hiveService: hiveService);
});

class RecipeLocalDatasource implements IRecipeDataSource {
  // ignore: unused_field
  final HiveService _hiveService;

  RecipeLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> createRecipe(RecipeModel recipe) async {
    try {
      // TODO: Implement Hive service method
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteRecipe(String recipeId) async {
    try {
      // TODO: Implement Hive service method
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<RecipeModel>> getAllRecipes() async {
    try {
      // TODO: Implement Hive service method
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<RecipeModel?> getRecipeById(String recipeId) async {
    try {
      // TODO: Implement Hive service method
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateRecipe(RecipeModel recipe) async {
    try {
      // TODO: Implement Hive service method
      return true;
    } catch (e) {
      return false;
    }
  }
}
