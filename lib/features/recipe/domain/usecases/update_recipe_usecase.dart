import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/recipe/data/repositories/recipe_repository_impl.dart';
import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:businesstrack/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateRecipeParams extends Equatable {
  final RecipeEntity recipe;

  const UpdateRecipeParams({required this.recipe});

  @override
  List<Object?> get props => [recipe];
}

final updateRecipeUsecaseProvider = Provider<UpdateRecipeUsecase>((ref) {
  final recipeRepository = ref.read(recipeRepositoryProvider);
  return UpdateRecipeUsecase(recipeRepository: recipeRepository);
});

class UpdateRecipeUsecase
    implements UsecasewithParams<bool, UpdateRecipeParams> {
  final IRecipeRepository _recipeRepository;

  UpdateRecipeUsecase({required IRecipeRepository recipeRepository})
    : _recipeRepository = recipeRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateRecipeParams params) {
    return _recipeRepository.updateRecipe(params.recipe);
  }
}
