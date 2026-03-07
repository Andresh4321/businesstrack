import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/recipe/data/repositories/recipe_repository_impl.dart';
import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:businesstrack/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRecipeParams extends Equatable {
  final String name;
  final String? description;
  final double sellingPrice;
  final List<IngredientEntity> ingredients;

  const CreateRecipeParams({
    required this.name,
    this.description,
    required this.sellingPrice,
    required this.ingredients,
  });

  @override
  List<Object?> get props => [name, description, sellingPrice, ingredients];
}

final createRecipeUsecaseProvider = Provider<CreateRecipeUsecase>((ref) {
  final recipeRepository = ref.read(recipeRepositoryProvider);
  return CreateRecipeUsecase(recipeRepository: recipeRepository);
});

class CreateRecipeUsecase
    implements UsecasewithParams<bool, CreateRecipeParams> {
  final IRecipeRepository _recipeRepository;

  CreateRecipeUsecase({required IRecipeRepository recipeRepository})
    : _recipeRepository = recipeRepository;

  @override
  Future<Either<Failure, bool>> call(CreateRecipeParams params) {
    final entity = RecipeEntity(
      name: params.name,
      description: params.description,
      sellingPrice: params.sellingPrice,
      ingredients: params.ingredients,
    );
    return _recipeRepository.createRecipe(entity);
  }
}
