import 'package:businesstrack/features/low_stock_alert/domain/entities/low_stock_alert_entity.dart';
import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:businesstrack/features/stock/domain/entities/stock_entity.dart';

enum DashboardStatus { initial, loading, loaded, error }

class DashboardState {
  final DashboardStatus status;
  final List<MaterialEntity> materials;
  final List<ProductionEntity> productions;
  final List<StockEntity> stocks;
  final List<LowStockAlertEntity> alerts;
  final String? errorMessage;

  // Computed stats
  int get totalMaterials => materials.length;

  double get totalInventoryValue => materials.fold<double>(
    0,
    (sum, material) => sum + (material.quantity * material.unitPrice),
  );

  double get totalMaterialQuantity =>
      materials.fold<double>(0, (sum, material) => sum + material.quantity);

  int get lowStockAlertCount =>
      alerts.where((alert) => !alert.isResolved).length;

  int get productionCount =>
      productions.where((p) => p.status == 'ongoing').length;

  int get completedProductionToday => productions
      .where((p) => _isToday(p.createdAt) && p.status == 'completed')
      .length;

  bool _isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.materials = const [],
    this.productions = const [],
    this.stocks = const [],
    this.alerts = const [],
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    List<MaterialEntity>? materials,
    List<ProductionEntity>? productions,
    List<StockEntity>? stocks,
    List<LowStockAlertEntity>? alerts,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      materials: materials ?? this.materials,
      productions: productions ?? this.productions,
      stocks: stocks ?? this.stocks,
      alerts: alerts ?? this.alerts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
