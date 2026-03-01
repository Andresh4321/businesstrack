import 'package:businesstrack/features/dashboard/presentation/state/dashboard_state.dart';
import 'package:businesstrack/features/low_stock_alert/data/repositories/low_stock_alert_repository_impl.dart';
import 'package:businesstrack/features/low_stock_alert/domain/entities/low_stock_alert_entity.dart';
import 'package:businesstrack/features/material/data/repositories/material_repository_impl.dart';
import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:businesstrack/features/production/data/repositories/production_repository_impl.dart';
import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:businesstrack/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:businesstrack/features/stock/domain/entities/stock_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardViewModelProvider =
    NotifierProvider<DashboardViewModel, DashboardState>(
      () => DashboardViewModel(),
    );

class DashboardViewModel extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    // Load initial data when viewmodel is created
    _loadDashboardData();
    return const DashboardState();
  }

  Future<void> _loadDashboardData() async {
    state = state.copyWith(status: DashboardStatus.loading);
    try {
      final materialRepository = ref.read(materialRepositoryProvider);
      final productionRepository = ref.read(productionRepositoryProvider);
      final stockRepository = ref.read(stockRepositoryProvider);
      final lowStockAlertRepository = ref.read(lowStockAlertRepositoryProvider);

      // Fetch all data in parallel
      final materialResult = await materialRepository.getAllMaterials();
      final productionResult = await productionRepository.getAllProduction();
      final stockResult = await stockRepository.getAllStock();
      final alertResult = await lowStockAlertRepository.getAllAlerts();

      final materials = materialResult.fold<List<dynamic>>(
        (_) => [],
        (data) => data,
      );
      final productions = productionResult.fold<List<dynamic>>(
        (_) => [],
        (data) => data,
      );
      final stocks = stockResult.fold<List<dynamic>>((_) => [], (data) => data);
      final alerts = alertResult.fold<List<dynamic>>((_) => [], (data) => data);

      state = state.copyWith(
        status: DashboardStatus.loaded,
        materials: materials.cast<MaterialEntity>(),
        productions: productions.cast<ProductionEntity>(),
        stocks: stocks.cast<StockEntity>(),
        alerts: alerts.cast<LowStockAlertEntity>(),
      );
    } catch (e) {
      state = state.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // Refresh dashboard data
  Future<void> refreshDashboard() async {
    await _loadDashboardData();
  }
}
