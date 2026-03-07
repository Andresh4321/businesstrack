import 'package:equatable/equatable.dart';

class DashboardMetricsEntity extends Equatable {
  final String id;
  final int totalMaterials;
  final int totalProducts;
  final int lowStockItems;
  final double totalInventoryValue;
  final DateTime lastUpdated;

  const DashboardMetricsEntity({
    required this.id,
    required this.totalMaterials,
    required this.totalProducts,
    required this.lowStockItems,
    required this.totalInventoryValue,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    id,
    totalMaterials,
    totalProducts,
    lowStockItems,
    totalInventoryValue,
    lastUpdated,
  ];
}
