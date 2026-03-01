import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/services/connectivity/network_info.dart';
import 'package:businesstrack/features/recipe/data/datasources/local/recipe_local_datasource.dart';
import 'package:businesstrack/features/recipe/data/datasources/recipe_datasource.dart';
import 'package:businesstrack/features/recipe/data/datasources/remote/recipe_remote_datasource.dart';
import 'package:businesstrack/features/recipe/data/models/recipe_model.dart';
import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:businesstrack/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipeRepositoryProvider = Provider<IRecipeRepository>((ref) {
  final recipeLocalDatasource = ref.read(recipeLocalDatasourceProvider);
  final recipeRemoteDatasource = ref.read(recipeRemoteProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return RecipeRepositoryImpl(
    recipeLocalDatasource: recipeLocalDatasource,
    recipeRemoteDatasource: recipeRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class RecipeRepositoryImpl implements IRecipeRepository {
  final IRecipeDataSource _recipeLocalDatasource;
  final IRecipeRemoteDataSource _recipeRemoteDatasource;
  final NetworkInfo _networkInfo;

  RecipeRepositoryImpl({
    required IRecipeDataSource recipeLocalDatasource,
    required IRecipeRemoteDataSource recipeRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _recipeLocalDatasource = recipeLocalDatasource,
       _recipeRemoteDatasource = recipeRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> createRecipe(RecipeEntity recipe) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = RecipeModel.fromEntity(recipe);
        final result = await _recipeRemoteDatasource.createRecipe(model);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          Apifailure(message: e.message ?? 'Failed to create recipe'),
        );
      }
    } else {
      try {
        final model = RecipeModel.fromEntity(recipe);
        final result = await _recipeLocalDatasource.createRecipe(model);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteRecipe(String recipeId) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _recipeRemoteDatasource.deleteRecipe(recipeId);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          Apifailure(message: e.message ?? 'Failed to delete recipe'),
        );
      }
    } else {
      try {
        final result = await _recipeLocalDatasource.deleteRecipe(recipeId);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<RecipeEntity>>> getAllRecipes() async {
    if (await _networkInfo.isConnected) {
      try {
        final recipes = await _recipeRemoteDatasource.getAllRecipes();
        return Right(RecipeModel.toEntityList(recipes));
      } on DioException catch (e) {
        return Left(
          Apifailure(message: e.message ?? 'Failed to fetch recipes'),
        );
      }
    } else {
      try {
        final recipes = await _recipeLocalDatasource.getAllRecipes();
        return Right(RecipeModel.toEntityList(recipes));
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, RecipeEntity>> getRecipeById(String recipeId) async {
    if (await _networkInfo.isConnected) {
      try {
        final recipe = await _recipeRemoteDatasource.getRecipeById(recipeId);
        if (recipe != null) {
          return Right(recipe.toEntity());
        }
        return Left(Apifailure(message: 'Recipe not found'));
      } on DioException catch (e) {
        return Left(ApiFailure(message: e.message ?? 'Failed to fetch recipe'));
      }
    } else {
      try {
        final recipe = await _recipeLocalDatasource.getRecipeById(recipeId);
        if (recipe != null) {
          return Right(recipe.toEntity());
        }
        return Left(LocalDatabaseFailure(messgae: 'Recipe not found'));
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> updateRecipe(RecipeEntity recipe) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = RecipeModel.fromEntity(recipe);
        final result = await _recipeRemoteDatasource.updateRecipe(model);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          Apifailure(message: e.message ?? 'Failed to update recipe'),
        );
      }
    } else {
      try {
        final model = RecipeModel.fromEntity(recipe);
        final result = await _recipeLocalDatasource.updateRecipe(model);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }
}
