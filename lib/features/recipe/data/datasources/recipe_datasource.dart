import 'package:businesstrack/features/recipe/data/models/recipe_model.dart';

abstract interface class IRecipeDataSource {
  Future<List<RecipeModel>> getAllRecipes();
  Future<RecipeModel?> getRecipeById(String recipeId);
  Future<bool> createRecipe(RecipeModel recipe);
  Future<bool> updateRecipe(RecipeModel recipe);
  Future<bool> deleteRecipe(String recipeId);
}

abstract interface class IRecipeRemoteDataSource {
  Future<List<RecipeModel>> getAllRecipes();
  Future<RecipeModel?> getRecipeById(String recipeId);
  Future<bool> createRecipe(RecipeModel recipe);
  Future<bool> updateRecipe(RecipeModel recipe);
  Future<bool> deleteRecipe(String recipeId);
}
