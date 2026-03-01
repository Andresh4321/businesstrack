import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IRecipeRepository {
  Future<Either<Failure, List<RecipeEntity>>> getAllRecipes();
  Future<Either<Failure, RecipeEntity>> getRecipeById(String recipeId);
  Future<Either<Failure, bool>> createRecipe(RecipeEntity recipe);
  Future<Either<Failure, bool>> updateRecipe(RecipeEntity recipe);
  Future<Either<Failure, bool>> deleteRecipe(String recipeId);
}
