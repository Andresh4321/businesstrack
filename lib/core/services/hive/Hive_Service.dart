import 'package:businesstrack/core/constants/hive_table_constant.dart';
import 'package:businesstrack/features/auth/data/models/auth_hive_model.dart';
import 'package:businesstrack/features/supplier/data/models/supplier_hive_model.dart';
import 'package:businesstrack/features/users/data/models/user_hive_model.dart';
import 'package:businesstrack/features/material/data/models/material_hive_model.dart';
import 'package:businesstrack/features/stock/data/models/stock_hive_model.dart';
import 'package:businesstrack/features/bill_of_materials/data/models/bill_of_materials_hive_model.dart';
import 'package:businesstrack/features/recipe/data/models/recipe_hive_model.dart';
import 'package:businesstrack/features/production/data/models/production_hive_model.dart';
import 'package:businesstrack/features/report/data/models/report_hive_model.dart';
import 'package:businesstrack/features/low_stock_alert/data/models/low_stock_alert_hive_model.dart';
import 'package:businesstrack/features/dashboard/data/models/dashboard_metrics_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  //Get user box
  Box<UserHiveModel> get _userBox =>
      Hive.box<UserHiveModel>(HiveTableConstant.userTable);

  //Initialize Hive
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapters();
    await _openBoxes();
    await insertDummyuseres();
  }

  Future<void> insertDummyuseres() async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userTable);
    final dummyuseres = [
      UserHiveModel(username: '35-A'),
      UserHiveModel(username: '35-B'),
      UserHiveModel(username: '35-C'),
      UserHiveModel(username: '35-D'),
    ];
    for (var user in dummyuseres) {
      await box.put(user.userId, user);
    }
    await box.close();
  }

  //Register all type adapters
  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.supplierTypeId)) {
      Hive.registerAdapter(SupplierHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.materialTypeId)) {
      Hive.registerAdapter(MaterialHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.stockTypeId)) {
      Hive.registerAdapter(StockHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.billOfMaterialsTypeId)) {
      Hive.registerAdapter(BillOfMaterialsHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.recipeTypeId)) {
      Hive.registerAdapter(RecipeHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.ingredientTypeId)) {
      Hive.registerAdapter(IngredientHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.productionTypeId)) {
      Hive.registerAdapter(ProductionHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.productionItemTypeId)) {
      Hive.registerAdapter(ProductionItemHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.reportTypeId)) {
      Hive.registerAdapter(ReportHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.lowStockAlertTypeId)) {
      Hive.registerAdapter(LowStockAlertHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.dashboardMetricsTypeId)) {
      Hive.registerAdapter(DashboardMetricsHiveModelAdapter());
    }
  }

  //Open all boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<UserHiveModel>(HiveTableConstant.userTable);
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    await Hive.openBox<SupplierHiveModel>(HiveTableConstant.suppliersTable);
    await Hive.openBox<MaterialHiveModel>(HiveTableConstant.materialsTable);
    await Hive.openBox<StockHiveModel>(HiveTableConstant.stockTable);
    await Hive.openBox<BillOfMaterialsHiveModel>(
      HiveTableConstant.billOfMaterialsTable,
    );
    await Hive.openBox<RecipeHiveModel>(HiveTableConstant.recipesTable);
    await Hive.openBox<ProductionHiveModel>(HiveTableConstant.productionTable);
    await Hive.openBox<ReportHiveModel>(HiveTableConstant.reportBox);
    await Hive.openBox<LowStockAlertHiveModel>(
      HiveTableConstant.lowStockAlertBox,
    );
    await Hive.openBox<DashboardMetricsHiveModel>(
      HiveTableConstant.dashboardMetricsBox,
    );
  }

  //Create a new user
  Future<UserHiveModel> createuser(UserHiveModel user) async {
    await _userBox.put(user.userId, user);
    return user;
  }

  //Get all useres
  List<UserHiveModel> getAlluseres() {
    return _userBox.values.toList();
  }

  //Get user by ID
  Future<UserHiveModel> getuserById(String userId) {
    final user = _userBox.get(userId);
    if (user == null) {
      throw Exception('user with ID $userId not found');
    }
    return Future.value(user);
  }

  //Update a user
  Future<void> updateuser(UserHiveModel user) async {
    await _userBox.put(user.userId, user);
  }

  //Delete a user
  Future<void> deleteuser(String userId) async {
    await _userBox.delete(userId);
  }

  //Delete all useres
  Future<void> deleteAlluseres() async {
    await _userBox.clear();
  }

  //Close all boxes
  Future<void> close() async {
    await Hive.close();
  }

  //-----------------Auth Queries
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
    return model;
  }

  AuthHiveModel? getUserByEmail(String email) {
    try {
      return _authBox.values.firstWhere(
        (user) => user.email?.toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  //Login
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
      (user) =>
          (user.email?.toLowerCase() == email.toLowerCase()) &&
          user.password == password,
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  //logout
  Future<void> logoutUser(String authId) async {
    await _authBox.delete(authId);
  }

  //get current user (most recently stored)
  AuthHiveModel? getCurrentUser() {
    if (_authBox.isEmpty) return null;
    // Using the last inserted user as the "current" one for offline mode.
    return _authBox.values.last;
  }

  bool isEmailExists(String email) {
    final users = _authBox.values.where(
      (user) => user.email?.toLowerCase() == email.toLowerCase(),
    );
    return users.isNotEmpty;
  }

  //-----------------Supplier Queries
  Box<SupplierHiveModel> get _supplierBox =>
      Hive.box<SupplierHiveModel>(HiveTableConstant.suppliersTable);

  /// Create a new supplier for a user
  Future<SupplierHiveModel> createSupplier(
    SupplierHiveModel supplier,
    String userId,
  ) async {
    final key = '${userId}_${supplier.id}';
    await _supplierBox.put(key, supplier);
    return supplier;
  }

  /// Get all suppliers for a specific user
  List<SupplierHiveModel> getSuppliersByUserId(String userId) {
    return _supplierBox.values
        .where((supplier) => supplier.id?.startsWith(userId) ?? false)
        .toList();
  }

  /// Get a specific supplier by ID for a user
  Future<SupplierHiveModel?> getSupplierById(
    String supplierId,
    String userId,
  ) async {
    final key = '${userId}_$supplierId';
    return _supplierBox.get(key);
  }

  /// Update a supplier
  Future<void> updateSupplier(SupplierHiveModel supplier, String userId) async {
    final key = '${userId}_${supplier.id}';
    await _supplierBox.put(key, supplier);
  }

  /// Delete a supplier
  Future<void> deleteSupplier(String supplierId, String userId) async {
    final key = '${userId}_$supplierId';
    await _supplierBox.delete(key);
  }

  /// Delete all suppliers for a user
  Future<void> deleteAllSuppliersByUserId(String userId) async {
    final keys = _supplierBox.keys
        .where((key) => key.toString().startsWith(userId))
        .toList();
    for (var key in keys) {
      await _supplierBox.delete(key);
    }
  }

  //-----------------Material Queries
  Box<MaterialHiveModel> get _materialBox =>
      Hive.box<MaterialHiveModel>(HiveTableConstant.materialsTable);

  Future<MaterialHiveModel> createMaterial(MaterialHiveModel material) async {
    await _materialBox.put(material.materialId, material);
    return material;
  }

  List<MaterialHiveModel> getAllMaterials() {
    return _materialBox.values.toList();
  }

  Future<MaterialHiveModel?> getMaterialById(String materialId) async {
    return _materialBox.get(materialId);
  }

  Future<void> updateMaterial(MaterialHiveModel material) async {
    await _materialBox.put(material.materialId, material);
  }

  Future<void> deleteMaterial(String materialId) async {
    await _materialBox.delete(materialId);
  }

  Future<void> deleteAllMaterials() async {
    await _materialBox.clear();
  }

  //-----------------Stock Queries
  Box<StockHiveModel> get _stockBox =>
      Hive.box<StockHiveModel>(HiveTableConstant.stockTable);

  Future<StockHiveModel> createStock(StockHiveModel stock) async {
    await _stockBox.put(stock.stockId, stock);
    return stock;
  }

  List<StockHiveModel> getAllStock() {
    return _stockBox.values.toList();
  }

  Future<StockHiveModel?> getStockById(String stockId) async {
    return _stockBox.get(stockId);
  }

  List<StockHiveModel> getStockByMaterialId(String materialId) {
    return _stockBox.values
        .where((stock) => stock.materialId == materialId)
        .toList();
  }

  Future<void> updateStock(StockHiveModel stock) async {
    await _stockBox.put(stock.stockId, stock);
  }

  Future<void> deleteStock(String stockId) async {
    await _stockBox.delete(stockId);
  }

  Future<void> deleteAllStock() async {
    await _stockBox.clear();
  }

  //-----------------Bill of Materials Queries
  Box<BillOfMaterialsHiveModel> get _billOfMaterialsBox =>
      Hive.box<BillOfMaterialsHiveModel>(
        HiveTableConstant.billOfMaterialsTable,
      );

  Future<BillOfMaterialsHiveModel> createBillItem(
    BillOfMaterialsHiveModel item,
  ) async {
    await _billOfMaterialsBox.put(item.billId, item);
    return item;
  }

  List<BillOfMaterialsHiveModel> getAllBillItems() {
    return _billOfMaterialsBox.values.toList();
  }

  Future<BillOfMaterialsHiveModel?> getBillItemById(String billId) async {
    return _billOfMaterialsBox.get(billId);
  }

  List<BillOfMaterialsHiveModel> getBillItemsByMaterialId(String materialId) {
    return _billOfMaterialsBox.values
        .where((item) => item.materialId == materialId)
        .toList();
  }

  Future<void> updateBillItem(BillOfMaterialsHiveModel item) async {
    await _billOfMaterialsBox.put(item.billId, item);
  }

  Future<void> deleteBillItem(String billId) async {
    await _billOfMaterialsBox.delete(billId);
  }

  Future<void> deleteAllBillItems() async {
    await _billOfMaterialsBox.clear();
  }

  //-----------------Recipe Queries
  Box<RecipeHiveModel> get _recipeBox =>
      Hive.box<RecipeHiveModel>(HiveTableConstant.recipesTable);

  Future<RecipeHiveModel> createRecipe(RecipeHiveModel recipe) async {
    await _recipeBox.put(recipe.recipeId, recipe);
    return recipe;
  }

  List<RecipeHiveModel> getAllRecipes() {
    return _recipeBox.values.toList();
  }

  Future<RecipeHiveModel?> getRecipeById(String recipeId) async {
    return _recipeBox.get(recipeId);
  }

  Future<void> updateRecipe(RecipeHiveModel recipe) async {
    await _recipeBox.put(recipe.recipeId, recipe);
  }

  Future<void> deleteRecipe(String recipeId) async {
    await _recipeBox.delete(recipeId);
  }

  Future<void> deleteAllRecipes() async {
    await _recipeBox.clear();
  }

  //-----------------Production Queries
  Box<ProductionHiveModel> get _productionBox =>
      Hive.box<ProductionHiveModel>(HiveTableConstant.productionTable);

  Future<ProductionHiveModel> createProduction(
    ProductionHiveModel production,
  ) async {
    await _productionBox.put(production.productionId, production);
    return production;
  }

  List<ProductionHiveModel> getAllProductions() {
    return _productionBox.values.toList();
  }

  Future<ProductionHiveModel?> getProductionById(String productionId) async {
    return _productionBox.get(productionId);
  }

  Future<void> updateProduction(ProductionHiveModel production) async {
    await _productionBox.put(production.productionId, production);
  }

  Future<void> deleteProduction(String productionId) async {
    await _productionBox.delete(productionId);
  }

  Future<void> deleteAllProductions() async {
    await _productionBox.clear();
  }

  //-----------------Report Queries
  Box<ReportHiveModel> get _reportBox =>
      Hive.box<ReportHiveModel>(HiveTableConstant.reportBox);

  Future<ReportHiveModel> createReport(ReportHiveModel report) async {
    await _reportBox.put(report.reportId, report);
    return report;
  }

  List<ReportHiveModel> getAllReports() {
    return _reportBox.values.toList();
  }

  Future<ReportHiveModel?> getReportById(String reportId) async {
    return _reportBox.get(reportId);
  }

  Future<void> updateReport(ReportHiveModel report) async {
    await _reportBox.put(report.reportId, report);
  }

  Future<void> deleteReport(String reportId) async {
    await _reportBox.delete(reportId);
  }

  Future<void> deleteAllReports() async {
    await _reportBox.clear();
  }

  //-----------------Low Stock Alert Queries
  Box<LowStockAlertHiveModel> get _lowStockAlertBox =>
      Hive.box<LowStockAlertHiveModel>(HiveTableConstant.lowStockAlertBox);

  Future<LowStockAlertHiveModel> createLowStockAlert(
    LowStockAlertHiveModel alert,
  ) async {
    await _lowStockAlertBox.put(alert.alertId, alert);
    return alert;
  }

  List<LowStockAlertHiveModel> getAllLowStockAlerts() {
    return _lowStockAlertBox.values.toList();
  }

  Future<LowStockAlertHiveModel?> getLowStockAlertById(String alertId) async {
    return _lowStockAlertBox.get(alertId);
  }

  List<LowStockAlertHiveModel> getLowStockAlertsByMaterialId(
    String materialId,
  ) {
    return _lowStockAlertBox.values
        .where((alert) => alert.materialId == materialId)
        .toList();
  }

  Future<void> updateLowStockAlert(LowStockAlertHiveModel alert) async {
    await _lowStockAlertBox.put(alert.alertId, alert);
  }

  Future<void> deleteLowStockAlert(String alertId) async {
    await _lowStockAlertBox.delete(alertId);
  }

  Future<void> deleteAllLowStockAlerts() async {
    await _lowStockAlertBox.clear();
  }

  //-----------------Dashboard Metrics Queries
  Box<DashboardMetricsHiveModel> get _dashboardMetricsBox =>
      Hive.box<DashboardMetricsHiveModel>(
        HiveTableConstant.dashboardMetricsBox,
      );

  Future<DashboardMetricsHiveModel> createDashboardMetrics(
    DashboardMetricsHiveModel metrics,
  ) async {
    await _dashboardMetricsBox.put(metrics.id, metrics);
    return metrics;
  }

  List<DashboardMetricsHiveModel> getAllDashboardMetrics() {
    return _dashboardMetricsBox.values.toList();
  }

  Future<DashboardMetricsHiveModel?> getDashboardMetricsById(String id) async {
    return _dashboardMetricsBox.get(id);
  }

  Future<void> updateDashboardMetrics(DashboardMetricsHiveModel metrics) async {
    await _dashboardMetricsBox.put(metrics.id, metrics);
  }

  Future<void> deleteDashboardMetrics(String id) async {
    await _dashboardMetricsBox.delete(id);
  }

  Future<void> deleteAllDashboardMetrics() async {
    await _dashboardMetricsBox.clear();
  }
}
