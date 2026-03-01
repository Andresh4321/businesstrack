class HiveTableConstant {
  HiveTableConstant._();

  //Database name
  static const String dbName = "businesstrack_db";

  static const int userTypeId = 0;
  static const String userTable = 'user_table';

  static const int authTypeId = 1;
  static const String authTable = 'auth_table';

  static const int supplierTypeId = 3;
  static const String suppliersTable = 'suppliers_table';

  static const int materialTypeId = 4;
  static const String materialsTable = 'materials_table';

  static const int stockTypeId = 5;
  static const String stockTable = 'stock_table';

  static const int billOfMaterialsTypeId = 6;
  static const String billOfMaterialsTable = 'bill_of_materials_table';

  static const int recipeTypeId = 7;
  static const String recipesTable = 'recipes_table';

  static const int ingredientTypeId = 8;
  static const String ingredientsTable = 'ingredients_table';

  static const int productionTypeId = 9;
  static const String productionTable = 'production_table';

  static const int reportTypeId = 10;
  static const String reportBox = 'report_box';

  static const int lowStockAlertTypeId = 11;
  static const String lowStockAlertBox = 'low_stock_alert_box';
}
