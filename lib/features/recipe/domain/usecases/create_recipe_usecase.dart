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
  final List<String>? materials;
  final List<int>? quantities;
  final String? unit;

  const CreateRecipeParams({
    required this.name,
    this.description,
    this.materials,
    this.quantities,
    this.unit,
  });

  @override
  List<Object?> get props => [name, description, materials, quantities, unit];
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
    final ingredientNames = params.materials ?? const <String>[];
    final ingredientQuantities = params.quantities ?? const <int>[];

    final ingredients = List<IngredientEntity>.generate(
      ingredientNames.length,
      (index) {
        final quantity = index < ingredientQuantities.length
            ? ingredientQuantities[index].toDouble()
            : 0.0;

        return IngredientEntity(
          name: ingredientNames[index],
          materialId: ingredientNames[index],
          quantity: quantity,
        );
      },
    );

    final entity = RecipeEntity(
      name: params.name,
      description: params.description,
      sellingPrice: 0,
      ingredients: ingredients,
    );
    return _recipeRepository.createRecipe(entity);
  }
}
