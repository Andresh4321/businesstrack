import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/recipe/data/repositories/recipe_repository_impl.dart';
import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:businesstrack/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllRecipesUsecaseProvider = Provider<GetAllRecipesUsecase>((ref) {
  final recipeRepository = ref.read(recipeRepositoryProvider);
  return GetAllRecipesUsecase(recipeRepository: recipeRepository);
});

class GetAllRecipesUsecase implements UsecasewithoutParams<List<RecipeEntity>> {
  final IRecipeRepository _recipeRepository;

  GetAllRecipesUsecase({required IRecipeRepository recipeRepository})
    : _recipeRepository = recipeRepository;

  @override
  Future<Either<Failure, List<RecipeEntity>>> call() {
    return _recipeRepository.getAllRecipes();
  }
}
