import 'package:businesstrack/core/api/api_client.dart';
import 'package:businesstrack/core/api/api_endpoints.dart';
import 'package:businesstrack/features/recipe/data/datasources/recipe_datasource.dart';
import 'package:businesstrack/features/recipe/data/models/recipe_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipeRemoteProvider = Provider<IRecipeRemoteDataSource>((ref) {
  return RecipeRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class RecipeRemoteDatasource implements IRecipeRemoteDataSource {
  final ApiClient _apiClient;

  RecipeRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<bool> createRecipe(RecipeModel recipe) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.recipes,
        data: recipe.toJson(),
      );
      return response.data['success'] == true;
    } on DioException catch (e) {
      print('Create recipe error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> deleteRecipe(String recipeId) async {
    try {
      final response = await _apiClient.delete(
        ApiEndpoints.recipeById(recipeId),
      );
      return response.data['success'] == true;
    } on DioException catch (e) {
      print('Delete recipe error: $e');
      rethrow;
    }
  }

  @override
  Future<List<RecipeModel>> getAllRecipes() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.recipes);
      if (response.data['success'] == true) {
        final data = response.data['data'] as List;
        return data
            .map((json) => RecipeModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      print('Get all recipes error: $e');
      rethrow;
    }
  }

  @override
  Future<RecipeModel?> getRecipeById(String recipeId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.recipeById(recipeId));
      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        return RecipeModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      print('Get recipe by ID error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> updateRecipe(RecipeModel recipe) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.recipeById(recipe.recipeId!),
        data: recipe.toJson(),
      );
      return response.data['success'] == true;
    } on DioException catch (e) {
      print('Update recipe error: $e');
      rethrow;
    }
  }
}
