import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/recipe/data/repositories/recipe_repository_impl.dart';
import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:businesstrack/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetRecipeByIdParams extends Equatable {
  final String recipeId;

  const GetRecipeByIdParams({required this.recipeId});

  @override
  List<Object?> get props => [recipeId];
}

final getRecipeByIdUsecaseProvider = Provider<GetRecipeByIdUsecase>((ref) {
  final recipeRepository = ref.read(recipeRepositoryProvider);
  return GetRecipeByIdUsecase(recipeRepository: recipeRepository);
});

class GetRecipeByIdUsecase
    implements UsecasewithParams<RecipeEntity, GetRecipeByIdParams> {
  final IRecipeRepository _recipeRepository;

  GetRecipeByIdUsecase({required IRecipeRepository recipeRepository})
    : _recipeRepository = recipeRepository;

  @override
  Future<Either<Failure, RecipeEntity>> call(GetRecipeByIdParams params) {
    return _recipeRepository.getRecipeById(params.recipeId);
  }
}
