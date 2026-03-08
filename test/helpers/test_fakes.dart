/// Test Fakes and Helper Functions
/// Simplified version matching actual codebase structure

import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/auth/domain/entities/auth_entity.dart';
import 'package:businesstrack/features/auth/domain/repository/auth_repository.dart';
import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:businesstrack/features/material/domain/repositories/material_repository.dart';
import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:businesstrack/features/production/domain/repositories/production_repository.dart';
import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:businesstrack/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:businesstrack/features/stock/domain/entities/stock_entity.dart';
import 'package:businesstrack/features/stock/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';

// Sample Entity Builders
AuthEntity sampleAuthEntity() => const AuthEntity(
  authId: 'auth-123',
  fullName: 'Test User',
  email: 'test@example.com',
  phoneNumber: '9876543210',
);

MaterialEntity sampleMaterialEntity() => const MaterialEntity(
  materialId: 'mat-123',
  name: 'Flour',
  unit: 'kg',
  unitPrice: 50.0,
  quantity: 100.0,
  minimumStock: 20.0,
);

RecipeEntity sampleRecipeEntity() => const RecipeEntity(
  recipeId: 'recipe-123',
  name: 'Bread',
  sellingPrice: 200.0,
  ingredients: [],
);

ProductionEntity sampleProductionEntity() => const ProductionEntity(
  productionId: 'prod-123',
  recipeId: 'recipe-123',
  batchQuantity: 10,
  estimatedOutput: 10,
  itemsUsed: [],
  status: 'ongoing',
);

StockEntity sampleStockEntity() => const StockEntity(
  stockId: 'stock-123',
  materialId: 'mat-123',
  quantity: 50.0,
  transactionType: 'in',
);

// Fake Auth Repository
class FakeAuthRepository implements IAuthRespository {
  Either<Failure, bool>? registerResult = const Right(true);
  Either<Failure, AuthEntity>? loginResult;
  AuthEntity? lastRegistered;

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    lastRegistered = entity;
    return registerResult ?? const Right(true);
  }

  @override
  Future<Either<Failure, AuthEntity>> Login(
    String email,
    String password,
  ) async {
    return loginResult ?? Right(sampleAuthEntity());
  }

  @override
  Future<Either<Failure, AuthEntity>> adminLogin(
    String email,
    String password,
  ) async {
    return Right(sampleAuthEntity());
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    return Right(sampleAuthEntity());
  }

  @override
  Future<Either<Failure, AuthEntity>> whoAmI() async {
    return Right(sampleAuthEntity());
  }

  @override
  Future<Either<Failure, AuthEntity>> updateProfile(AuthEntity entity) async {
    return Right(sampleAuthEntity());
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(String filePath) async {
    return const Right('photo.jpg');
  }

  @override
  Future<Either<Failure, bool>> forgotPassword(String email) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> resetPassword(
    String token,
    String newPassword,
  ) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return const Right(null);
  }
}

// Fake Material Repository
class FakeMaterialRepository implements IMaterialRepository {
  Either<Failure, bool>? addResult = const Right(true);
  MaterialEntity? lastAdded;

  @override
  Future<Either<Failure, bool>> addMaterial(MaterialEntity material) async {
    lastAdded = material;
    return addResult ?? const Right(true);
  }

  @override
  Future<Either<Failure, bool>> updateMaterial(MaterialEntity material) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> deleteMaterial(String materialId) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, List<MaterialEntity>>> getAllMaterials() async {
    return Right([sampleMaterialEntity()]);
  }

  @override
  Future<Either<Failure, MaterialEntity>> getMaterialById(
    String materialId,
  ) async {
    return Right(sampleMaterialEntity());
  }

  @override
  Future<Either<Failure, List<MaterialEntity>>> searchMaterials(
    String query,
  ) async {
    return Right([sampleMaterialEntity()]);
  }
}

// Fake Recipe Repository
class FakeRecipeRepository implements IRecipeRepository {
  Either<Failure, bool>? createResult = const Right(true);
  RecipeEntity? lastCreated;

  @override
  Future<Either<Failure, bool>> createRecipe(RecipeEntity recipe) async {
    lastCreated = recipe;
    return createResult ?? const Right(true);
  }

  @override
  Future<Either<Failure, bool>> updateRecipe(RecipeEntity recipe) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> deleteRecipe(String recipeId) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, List<RecipeEntity>>> getAllRecipes() async {
    return Right([sampleRecipeEntity()]);
  }

  @override
  Future<Either<Failure, RecipeEntity>> getRecipeById(String recipeId) async {
    return Right(sampleRecipeEntity());
  }
}

// Fake Production Repository
class FakeProductionRepository implements IProductionRepository {
  Either<Failure, bool>? startResult = const Right(true);
  ProductionEntity? lastStarted;

  @override
  Future<Either<Failure, bool>> startProduction(
    ProductionEntity production,
  ) async {
    lastStarted = production;
    return startResult ?? const Right(true);
  }

  @override
  Future<Either<Failure, bool>> updateProduction(
    ProductionEntity production,
  ) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> endProduction(
    String productionId, {
    double? actualOutput,
  }) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> deleteProduction(String productionId) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, List<ProductionEntity>>> getAllProduction() async {
    return Right([sampleProductionEntity()]);
  }

  @override
  Future<Either<Failure, ProductionEntity>> getProductionById(
    String productionId,
  ) async {
    return Right(sampleProductionEntity());
  }
}

// Fake Stock Repository
class FakeStockRepository implements IStockRepository {
  @override
  Future<Either<Failure, bool>> createStockTransaction({
    required String materialId,
    required double quantity,
    required String transactionType,
    String? description,
  }) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> addStock(StockEntity stock) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> updateStock(StockEntity stock) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> deleteStock(String stockId) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> deleteStockTransaction(
    String transactionId,
  ) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, List<StockEntity>>> getAllStock() async {
    return Right([sampleStockEntity()]);
  }

  @override
  Future<Either<Failure, List<StockEntity>>> getAllStockTransactions() async {
    return Right([sampleStockEntity()]);
  }

  @override
  Future<Either<Failure, StockEntity>> getStockById(String stockId) async {
    return Right(sampleStockEntity());
  }
}
