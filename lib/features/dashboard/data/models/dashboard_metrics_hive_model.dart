import 'package:businesstrack/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:hive/hive.dart';

part 'dashboard_metrics_hive_model.g.dart';

@HiveType(typeId: 21)
class DashboardMetricsHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int totalMaterials;

  @HiveField(2)
  final int totalProducts;

  @HiveField(3)
  final int lowStockItems;

  @HiveField(4)
  final double totalInventoryValue;

  @HiveField(5)
  final DateTime lastUpdated;

  DashboardMetricsHiveModel({
    required this.id,
    required this.totalMaterials,
    required this.totalProducts,
    required this.lowStockItems,
    required this.totalInventoryValue,
    required this.lastUpdated,
  });

  // To Entity
  DashboardMetricsEntity toEntity() {
    return DashboardMetricsEntity(
      id: id,
      totalMaterials: totalMaterials,
      totalProducts: totalProducts,
      lowStockItems: lowStockItems,
      totalInventoryValue: totalInventoryValue,
      lastUpdated: lastUpdated,
    );
  }

  // From Entity
  factory DashboardMetricsHiveModel.fromEntity(DashboardMetricsEntity entity) {
    return DashboardMetricsHiveModel(
      id: entity.id,
      totalMaterials: entity.totalMaterials,
      totalProducts: entity.totalProducts,
      lowStockItems: entity.lowStockItems,
      totalInventoryValue: entity.totalInventoryValue,
      lastUpdated: entity.lastUpdated,
    );
  }
}
