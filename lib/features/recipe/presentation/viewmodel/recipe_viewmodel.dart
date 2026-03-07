import 'package:businesstrack/features/recipe/data/repositories/recipe_repository_impl.dart';
import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:businesstrack/features/recipe/domain/usecases/create_recipe_usecase.dart';
import 'package:businesstrack/features/recipe/domain/usecases/delete_recipe_usecase.dart';
import 'package:businesstrack/features/recipe/domain/usecases/get_all_recipes_usecase.dart';
import 'package:businesstrack/features/recipe/domain/usecases/update_recipe_usecase.dart';
import 'package:businesstrack/features/recipe/presentation/state/recipe_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipeViewModelProvider = NotifierProvider<RecipeViewModel, RecipeState>(
  () => RecipeViewModel(),
);

class RecipeViewModel extends Notifier<RecipeState> {
  late final CreateRecipeUsecase _createRecipeUsecase;
  late final GetAllRecipesUsecase _getAllRecipesUsecase;
  late final DeleteRecipeUsecase _deleteRecipeUsecase;
  late final UpdateRecipeUsecase _updateRecipeUsecase;

  @override
  RecipeState build() {
    _createRecipeUsecase = ref.read(createRecipeUsecaseProvider);
    _getAllRecipesUsecase = ref.read(getAllRecipesUsecaseProvider);
    _deleteRecipeUsecase = ref.read(deleteRecipeUsecaseProvider);
    _updateRecipeUsecase = ref.read(updateRecipeUsecaseProvider);
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

    final result = await _createRecipeUsecase(
      CreateRecipeParams(
        name: name,
        description: description,
        sellingPrice: sellingPrice,
        ingredients: ingredients,
      ),
    );

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
    final result = await _getAllRecipesUsecase();

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
    final result = await _deleteRecipeUsecase(
      DeleteRecipeParams(recipeId: recipeId),
    );

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
    final result = await _updateRecipeUsecase(
      UpdateRecipeParams(recipe: recipe),
    );

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
