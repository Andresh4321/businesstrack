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

  List<RecipeEntity> _sortByLatest(List<RecipeEntity> items) {
    final sorted = List<RecipeEntity>.from(items);
    sorted.sort((a, b) {
      final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
    return sorted;
  }

  Future<void> _cacheRemoteToLocal(List<RecipeModel> remoteRecipes) async {
    for (final recipe in remoteRecipes) {
      try {
        await _recipeLocalDatasource.createRecipe(recipe);
      } catch (_) {}
    }
  }

  @override
  Future<Either<Failure, bool>> createRecipe(RecipeEntity recipe) async {
    try {
      final model = RecipeModel.fromEntity(recipe);

      final localResult = await _recipeLocalDatasource.createRecipe(model);
      if (!localResult) {
        return Left(
          LocalDatabaseFailure(messgae: 'Failed to save recipe locally'),
        );
      }

      if (await _networkInfo.isConnected) {
        try {
          await _recipeRemoteDatasource.createRecipe(model);
        } catch (_) {}
      }

      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteRecipe(String recipeId) async {
    try {
      final localResult = await _recipeLocalDatasource.deleteRecipe(recipeId);
      if (!localResult) {
        return Left(
          LocalDatabaseFailure(messgae: 'Failed to delete recipe locally'),
        );
      }

      if (await _networkInfo.isConnected) {
        try {
          await _recipeRemoteDatasource.deleteRecipe(recipeId);
        } catch (_) {}
      }

      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RecipeEntity>>> getAllRecipes() async {
    try {
      final localRecipes = await _recipeLocalDatasource.getAllRecipes();

      if (localRecipes.isNotEmpty || !(await _networkInfo.isConnected)) {
        return Right(_sortByLatest(RecipeModel.toEntityList(localRecipes)));
      }

      final remoteRecipes = await _recipeRemoteDatasource.getAllRecipes();
      await _cacheRemoteToLocal(remoteRecipes);
      return Right(_sortByLatest(RecipeModel.toEntityList(remoteRecipes)));
    } on DioException catch (e) {
      return Left(Apifailure(message: e.message ?? 'Failed to fetch recipes'));
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecipeEntity>> getRecipeById(String recipeId) async {
    try {
      final localRecipe = await _recipeLocalDatasource.getRecipeById(recipeId);
      if (localRecipe != null) {
        return Right(localRecipe.toEntity());
      }

      if (await _networkInfo.isConnected) {
        final remoteRecipe = await _recipeRemoteDatasource.getRecipeById(
          recipeId,
        );
        if (remoteRecipe != null) {
          try {
            await _recipeLocalDatasource.createRecipe(remoteRecipe);
          } catch (_) {}
          return Right(remoteRecipe.toEntity());
        }
      }

      return Left(LocalDatabaseFailure(messgae: 'Recipe not found'));
    } on DioException catch (e) {
      return Left(ApiFailure(message: e.message ?? 'Failed to fetch recipe'));
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateRecipe(RecipeEntity recipe) async {
    try {
      final model = RecipeModel.fromEntity(recipe);

      final localResult = await _recipeLocalDatasource.updateRecipe(model);
      if (!localResult) {
        return Left(
          LocalDatabaseFailure(messgae: 'Failed to update recipe locally'),
        );
      }

      if (await _networkInfo.isConnected) {
        try {
          await _recipeRemoteDatasource.updateRecipe(model);
        } catch (_) {}
      }

      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }
}
