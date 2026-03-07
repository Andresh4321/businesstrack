import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/recipe/data/repositories/recipe_repository_impl.dart';
import 'package:businesstrack/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteRecipeParams extends Equatable {
  final String recipeId;

  const DeleteRecipeParams({required this.recipeId});

  @override
  List<Object?> get props => [recipeId];
}

final deleteRecipeUsecaseProvider = Provider<DeleteRecipeUsecase>((ref) {
  final recipeRepository = ref.read(recipeRepositoryProvider);
  return DeleteRecipeUsecase(recipeRepository: recipeRepository);
});

class DeleteRecipeUsecase
    implements UsecasewithParams<bool, DeleteRecipeParams> {
  final IRecipeRepository _recipeRepository;

  DeleteRecipeUsecase({required IRecipeRepository recipeRepository})
    : _recipeRepository = recipeRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteRecipeParams params) {
    return _recipeRepository.deleteRecipe(params.recipeId);
  }
}
