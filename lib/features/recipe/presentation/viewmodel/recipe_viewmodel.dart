import 'package:businesstrack/features/recipe/data/repositories/recipe_repository_impl.dart';
import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:businesstrack/features/recipe/domain/usecases/create_recipe_usecase.dart';
import 'package:businesstrack/features/recipe/presentation/state/recipe_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipeViewModelProvider = NotifierProvider<RecipeViewModel, RecipeState>(
  () => RecipeViewModel(),
);

class RecipeViewModel extends Notifier<RecipeState> {
  late final CreateRecipeUsecase _createRecipeUsecase;

  @override
  RecipeState build() {
    _createRecipeUsecase = ref.read(createRecipeUsecaseProvider);
    return const RecipeState();
  }

  // Create Recipe
  Future<bool> createRecipe({
    required String name,
    String? description,
    required double sellingPrice,
    required List<IngredientEntity> ingredients,
  }) async {
    state = state.copyWith(status: RecipeStatus.loading);

    final recipe = RecipeEntity(
      name: name,
      description: description,
      sellingPrice: sellingPrice,
      ingredients: ingredients,
    );

    final repository = ref.read(recipeRepositoryProvider);
    final result = await repository.createRecipe(recipe);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: RecipeStatus.error,
          errorMessage: failure.message,
        );
      },
      (isCreated) {
        state = state.copyWith(status: RecipeStatus.loaded);
        getAllRecipes(); // Refresh list
      },
    );

    return result.fold((_) => false, (isCreated) => isCreated);
  }

  // Get All Recipes
  Future<void> getAllRecipes() async {
    state = state.copyWith(status: RecipeStatus.loading);

    final repository = ref.read(recipeRepositoryProvider);
    final result = await repository.getAllRecipes();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: RecipeStatus.error,
          errorMessage: failure.message,
        );
      },
      (recipes) {
        state = state.copyWith(status: RecipeStatus.loaded, recipes: recipes);
      },
    );
  }

  // Delete Recipe
  Future<bool> deleteRecipe(String recipeId) async {
    state = state.copyWith(status: RecipeStatus.loading);

    final repository = ref.read(recipeRepositoryProvider);
    final result = await repository.deleteRecipe(recipeId);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: RecipeStatus.error,
          errorMessage: failure.message,
        );
      },
      (isDeleted) {
        state = state.copyWith(status: RecipeStatus.loaded);
        getAllRecipes(); // Refresh list
      },
    );

    return result.fold((_) => false, (isDeleted) => isDeleted);
  }

  // Update Recipe
  Future<bool> updateRecipe(RecipeEntity recipe) async {
    state = state.copyWith(status: RecipeStatus.loading);

    final repository = ref.read(recipeRepositoryProvider);
    final result = await repository.updateRecipe(recipe);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: RecipeStatus.error,
          errorMessage: failure.message,
        );
      },
      (isUpdated) {
        state = state.copyWith(status: RecipeStatus.loaded);
        getAllRecipes(); // Refresh list
      },
    );

    return result.fold((_) => false, (isUpdated) => isUpdated);
  }
}
