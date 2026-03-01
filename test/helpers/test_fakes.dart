import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/auth/domain/entities/auth_entity.dart';
import 'package:businesstrack/features/auth/domain/repository/auth_repository.dart';
import 'package:businesstrack/features/low_stock_alert/domain/entities/low_stock_alert_entity.dart';
import 'package:businesstrack/features/low_stock_alert/domain/entities/low_stock_item_entity.dart';
import 'package:businesstrack/features/low_stock_alert/domain/repositories/low_stock_alert_repository.dart'
    as alerts_repo;
import 'package:businesstrack/features/low_stock_alert/domain/repository/low_stock_alert_repository.dart'
    as items_repo;
import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:businesstrack/features/material/domain/repositories/material_repository.dart';
import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:businesstrack/features/production/domain/repositories/production_repository.dart';
import 'package:businesstrack/features/recipe/domain/entities/recipe_entity.dart';
import 'package:businesstrack/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:businesstrack/features/report/domain/entities/report_entity.dart';
import 'package:businesstrack/features/report/domain/repository/report_repository.dart';
import 'package:businesstrack/features/stock/domain/entities/stock_entity.dart';
import 'package:businesstrack/features/stock/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';

class FakeAuthRepository implements IAuthRespository {
  Either<Failure, bool> registerResult = const Right(true);
  Either<Failure, AuthEntity> loginResult = Right(sampleAuthEntity());
  Either<Failure, AuthEntity> currentUserResult = Right(sampleAuthEntity());
  Either<Failure, void> logoutResult = const Right(null);
  AuthEntity? lastRegistered;
  String? lastLoginEmail;
  String? lastLoginPassword;

  @override
  Future<Either<Failure, AuthEntity>> Login(
    String email,
    String password,
  ) async {
    lastLoginEmail = email;
    lastLoginPassword = password;
    return loginResult;
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    return currentUserResult;
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    lastRegistered = entity;
    return registerResult;
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return logoutResult;
  }
}

class FakeMaterialRepository implements IMaterialRepository {
  Either<Failure, bool> addResult = const Right(true);
  Either<Failure, bool> updateResult = const Right(true);
  Either<Failure, bool> deleteResult = const Right(true);
  Either<Failure, List<MaterialEntity>> allResult = Right([sampleMaterial()]);
  Either<Failure, MaterialEntity> byIdResult = Right(sampleMaterial());
  Either<Failure, List<MaterialEntity>> searchResult = Right([
    sampleMaterial(),
  ]);
  MaterialEntity? lastAdded;
  MaterialEntity? lastUpdated;

  @override
  Future<Either<Failure, bool>> addMaterial(MaterialEntity material) async {
    lastAdded = material;
    return addResult;
  }

  @override
  Future<Either<Failure, bool>> deleteMaterial(String materialId) async {
    return deleteResult;
  }

  @override
  Future<Either<Failure, List<MaterialEntity>>> getAllMaterials() async {
    return allResult;
  }

  @override
  Future<Either<Failure, MaterialEntity>> getMaterialById(
    String materialId,
  ) async {
    return byIdResult;
  }

  @override
  Future<Either<Failure, List<MaterialEntity>>> searchMaterials(
    String query,
  ) async {
    return searchResult;
  }

  @override
  Future<Either<Failure, bool>> updateMaterial(MaterialEntity material) async {
    lastUpdated = material;
    return updateResult;
  }
}

class FakeStockRepository implements IStockRepository {
  Either<Failure, bool> addResult = const Right(true);
  Either<Failure, bool> createTxnResult = const Right(true);
  Either<Failure, bool> deleteResult = const Right(true);
  Either<Failure, bool> deleteTxnResult = const Right(true);
  Either<Failure, List<StockEntity>> allStockResult = Right([sampleStock()]);
  Either<Failure, List<StockEntity>> allTxnResult = Right([sampleStock()]);
  Either<Failure, StockEntity> byIdResult = Right(sampleStock());
  Either<Failure, bool> updateResult = const Right(true);
  StockEntity? lastUpdated;
  String? lastMaterialId;
  double? lastQuantity;
  String? lastTransactionType;
  String? lastDescription;

  @override
  Future<Either<Failure, bool>> addStock(StockEntity stock) async {
    return addResult;
  }

  @override
  Future<Either<Failure, bool>> createStockTransaction({
    required String materialId,
    required double quantity,
    required String transactionType,
    String? description,
  }) async {
    lastMaterialId = materialId;
    lastQuantity = quantity;
    lastTransactionType = transactionType;
    lastDescription = description;
    return createTxnResult;
  }

  @override
  Future<Either<Failure, bool>> deleteStock(String stockId) async {
    return deleteResult;
  }

  @override
  Future<Either<Failure, bool>> deleteStockTransaction(
    String transactionId,
  ) async {
    return deleteTxnResult;
  }

  @override
  Future<Either<Failure, List<StockEntity>>> getAllStock() async {
    return allStockResult;
  }

  @override
  Future<Either<Failure, List<StockEntity>>> getAllStockTransactions() async {
    return allTxnResult;
  }

  @override
  Future<Either<Failure, StockEntity>> getStockById(String stockId) async {
    return byIdResult;
  }

  @override
  Future<Either<Failure, bool>> updateStock(StockEntity stock) async {
    lastUpdated = stock;
    return updateResult;
  }
}

class FakeRecipeRepository implements IRecipeRepository {
  Either<Failure, bool> createResult = const Right(true);
  Either<Failure, bool> updateResult = const Right(true);
  Either<Failure, bool> deleteResult = const Right(true);
  Either<Failure, List<RecipeEntity>> allResult = Right([sampleRecipe()]);
  Either<Failure, RecipeEntity> byIdResult = Right(sampleRecipe());
  RecipeEntity? lastCreated;

  @override
  Future<Either<Failure, bool>> createRecipe(RecipeEntity recipe) async {
    lastCreated = recipe;
    return createResult;
  }

  @override
  Future<Either<Failure, bool>> deleteRecipe(String recipeId) async {
    return deleteResult;
  }

  @override
  Future<Either<Failure, List<RecipeEntity>>> getAllRecipes() async {
    return allResult;
  }

  @override
  Future<Either<Failure, RecipeEntity>> getRecipeById(String recipeId) async {
    return byIdResult;
  }

  @override
  Future<Either<Failure, bool>> updateRecipe(RecipeEntity recipe) async {
    return updateResult;
  }
}

class FakeProductionRepository implements IProductionRepository {
  Either<Failure, bool> startResult = const Right(true);
  Either<Failure, bool> updateResult = const Right(true);
  Either<Failure, bool> endResult = const Right(true);
  Either<Failure, List<ProductionEntity>> allResult = Right([
    sampleProduction(),
  ]);
  Either<Failure, ProductionEntity> byIdResult = Right(sampleProduction());
  ProductionEntity? lastStarted;
  String? lastEndedId;
  double? lastActualOutput;

  @override
  Future<Either<Failure, bool>> endProduction(
    String productionId, {
    double? actualOutput,
  }) async {
    lastEndedId = productionId;
    lastActualOutput = actualOutput;
    return endResult;
  }

  @override
  Future<Either<Failure, List<ProductionEntity>>> getAllProduction() async {
    return allResult;
  }

  @override
  Future<Either<Failure, ProductionEntity>> getProductionById(
    String productionId,
  ) async {
    return byIdResult;
  }

  @override
  Future<Either<Failure, bool>> startProduction(
    ProductionEntity production,
  ) async {
    lastStarted = production;
    return startResult;
  }

  @override
  Future<Either<Failure, bool>> updateProduction(
    ProductionEntity production,
  ) async {
    return updateResult;
  }
}

class FakeLowStockAlertsRepository
    implements alerts_repo.ILowStockAlertRepository {
  Either<Failure, List<LowStockAlertEntity>> allResult = Right([
    sampleLowStockAlert(),
  ]);
  Either<Failure, List<LowStockAlertEntity>> unresolvedResult = Right([
    sampleLowStockAlert(),
  ]);
  Either<Failure, LowStockAlertEntity> byIdResult = Right(
    sampleLowStockAlert(),
  );
  Either<Failure, bool> createResult = const Right(true);
  Either<Failure, bool> resolveResult = const Right(true);
  Either<Failure, bool> deleteResult = const Right(true);
  Either<Failure, List<LowStockAlertEntity>> checkResult = Right([
    sampleLowStockAlert(),
  ]);
  String? lastResolvedId;
  String? lastResolvedBy;

  @override
  Future<Either<Failure, List<LowStockAlertEntity>>>
  checkLowStockItems() async {
    return checkResult;
  }

  @override
  Future<Either<Failure, bool>> createAlert(LowStockAlertEntity alert) async {
    return createResult;
  }

  @override
  Future<Either<Failure, bool>> deleteAlert(String alertId) async {
    return deleteResult;
  }

  @override
  Future<Either<Failure, LowStockAlertEntity>> getAlertById(
    String alertId,
  ) async {
    return byIdResult;
  }

  @override
  Future<Either<Failure, List<LowStockAlertEntity>>> getAllAlerts() async {
    return allResult;
  }

  @override
  Future<Either<Failure, List<LowStockAlertEntity>>>
  getUnresolvedAlerts() async {
    return unresolvedResult;
  }

  @override
  Future<Either<Failure, bool>> resolveAlert(
    String alertId,
    String resolvedBy,
  ) async {
    lastResolvedId = alertId;
    lastResolvedBy = resolvedBy;
    return resolveResult;
  }
}

class FakeLowStockItemsRepository
    implements items_repo.ILowStockAlertRepository {
  Either<Failure, List<LowStockItemEntity>> lowItemsResult = Right([
    sampleLowStockItem(),
  ]);
  Either<Failure, List<LowStockItemEntity>> criticalItemsResult = Right([
    sampleLowStockItem(),
  ]);

  @override
  Future<Either<Failure, List<LowStockItemEntity>>>
  getCriticalStockItems() async {
    return criticalItemsResult;
  }

  @override
  Future<Either<Failure, List<LowStockItemEntity>>> getLowStockItems() async {
    return lowItemsResult;
  }
}

class FakeReportRepository implements IReportRepository {
  Either<Failure, ReportEntity> stockSummaryResult = Right(
    sampleReport(type: 'stock'),
  );
  Either<Failure, ReportEntity> productionSummaryResult = Right(
    sampleReport(type: 'production'),
  );
  Either<Failure, ReportEntity> materialUsageResult = Right(
    sampleReport(type: 'material'),
  );
  Either<Failure, List<ReportEntity>> savedResult = Right([sampleReport()]);
  Either<Failure, bool> saveResult = const Right(true);
  Either<Failure, bool> deleteResult = const Right(true);

  @override
  Future<Either<Failure, bool>> deleteReport(String reportId) async {
    return deleteResult;
  }

  @override
  Future<Either<Failure, ReportEntity>> generateMaterialUsageReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return materialUsageResult;
  }

  @override
  Future<Either<Failure, ReportEntity>>
  generateProductionSummaryReport() async {
    return productionSummaryResult;
  }

  @override
  Future<Either<Failure, ReportEntity>> generateStockSummaryReport() async {
    return stockSummaryResult;
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> getSavedReports() async {
    return savedResult;
  }

  @override
  Future<Either<Failure, bool>> saveReport(ReportEntity report) async {
    return saveResult;
  }
}

AuthEntity sampleAuthEntity() => const AuthEntity(
  authId: 'auth-1',
  fullName: 'Test User',
  email: 'test@example.com',
  phoneNumber: '9800000000',
  password: 'password',
);

MaterialEntity sampleMaterial() => const MaterialEntity(
  materialId: 'mat-1',
  name: 'Flour',
  unit: 'kg',
  unitPrice: 50,
  quantity: 10,
  minimumStock: 3,
  description: 'Fine flour',
);

StockEntity sampleStock() => const StockEntity(
  stockId: 'stock-1',
  materialId: 'mat-1',
  quantity: 5,
  transactionType: 'in',
  description: 'restock',
);

RecipeEntity sampleRecipe() => const RecipeEntity(
  recipeId: 'rec-1',
  name: 'Bread',
  description: 'Basic bread',
  sellingPrice: 120,
  ingredients: [
    IngredientEntity(name: 'Flour', materialId: 'mat-1', quantity: 2),
  ],
);

ProductionEntity sampleProduction() => const ProductionEntity(
  productionId: 'prod-1',
  recipeId: 'rec-1',
  batchQuantity: 10,
  estimatedOutput: 10,
  itemsUsed: [],
  status: 'ongoing',
);

LowStockAlertEntity sampleLowStockAlert() => const LowStockAlertEntity(
  alertId: 'alert-1',
  materialId: 'mat-1',
  materialName: 'Flour',
  currentQuantity: 1,
  thresholdQuantity: 5,
  severity: 'critical',
);

LowStockItemEntity sampleLowStockItem() => const LowStockItemEntity(
  materialId: 'mat-1',
  materialName: 'Flour',
  unit: 'kg',
  unitPrice: 50,
  currentQuantity: 2,
  minimumStock: 10,
);

ReportEntity sampleReport({String type = 'stock'}) => ReportEntity(
  reportId: 'report-1',
  title: 'Test Report',
  type: type,
  data: const {'total': 1},
  generatedAt: DateTime(2024, 1, 1),
);
