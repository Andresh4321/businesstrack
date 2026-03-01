import 'package:businesstrack/core/api/api_client.dart';
import 'package:businesstrack/core/api/api_endpoints.dart';
import 'package:businesstrack/features/report/data/datasource/report_datasource.dart';
import 'package:businesstrack/features/report/data/models/report_model.dart';

class ReportRemoteDataSource implements IReportRemoteDataSource {
  final ApiClient apiClient;

  ReportRemoteDataSource({required this.apiClient});

  @override
  Future<ReportModel> generateStockSummaryReport() async {
    try {
      // Call multiple endpoints to aggregate data
      final stockResponse = await apiClient.get(ApiEndpoints.stockCurrent);
      final materialsResponse = await apiClient.get(ApiEndpoints.materials);

      final stockData = stockResponse.data['data'] as List<dynamic>;
      final materialsData = materialsResponse.data['data'] as List<dynamic>;

      // Calculate statistics
      double totalStockValue = 0;
      int lowStockCount = 0;
      int criticalStockCount = 0;

      final List<Map<String, dynamic>> topMaterials = [];

      for (var stock in stockData) {
        final material = stock['material'] as Map<String, dynamic>?;
        if (material != null) {
          final quantity = (stock['quantity'] ?? 0).toDouble();
          final unitPrice = (material['unit_price'] ?? 0).toDouble();
          final minimumStock = (material['minimum_stock'] ?? 0).toDouble();

          totalStockValue += quantity * unitPrice;

          if (quantity < minimumStock) {
            lowStockCount++;
            if (quantity < minimumStock * 0.25) {
              criticalStockCount++;
            }
          }

          topMaterials.add({
            'materialId': material['_id'],
            'materialName': material['name'],
            'quantity': quantity,
            'value': quantity * unitPrice,
            'unit': material['unit'],
          });
        }
      }

      // Sort by value and take top 10
      topMaterials.sort(
        (a, b) => (b['value'] as double).compareTo(a['value'] as double),
      );
      final top10 = topMaterials.take(10).toList();

      final reportData = {
        'totalMaterials': materialsData.length,
        'lowStockCount': lowStockCount,
        'criticalStockCount': criticalStockCount,
        'totalStockValue': totalStockValue,
        'topMaterials': top10,
      };

      return ReportModel(
        title: 'Stock Summary Report',
        type: 'stock_summary',
        generatedAt: DateTime.now(),
        data: reportData,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReportModel> generateProductionSummaryReport() async {
    try {
      final response = await apiClient.get(ApiEndpoints.production);
      final productionsData = response.data['data'] as List<dynamic>;

      int ongoingCount = 0;
      int completedCount = 0;
      double totalOutput = 0;
      double totalWastage = 0;

      final Map<String, Map<String, dynamic>> recipeStats = {};

      for (var production in productionsData) {
        final status = production['status'] ?? '';
        if (status == 'ongoing') {
          ongoingCount++;
        } else if (status == 'completed') {
          completedCount++;
          totalOutput += (production['actual_output'] ?? 0).toDouble();
          totalWastage += (production['wastage'] ?? 0).toDouble();
        }

        // Aggregate by recipe
        final recipeId = production['recipe']?['_id'] ?? production['recipe'];
        if (recipeId != null) {
          if (!recipeStats.containsKey(recipeId)) {
            recipeStats[recipeId] = {
              'recipeId': recipeId,
              'recipeName': production['recipe']?['name'] ?? 'Unknown',
              'productionCount': 0,
              'totalOutput': 0.0,
            };
          }
          recipeStats[recipeId]!['productionCount'] =
              (recipeStats[recipeId]!['productionCount'] as int) + 1;
          if (status == 'completed') {
            recipeStats[recipeId]!['totalOutput'] =
                (recipeStats[recipeId]!['totalOutput'] as double) +
                (production['actual_output'] ?? 0).toDouble();
          }
        }
      }

      final topRecipes = recipeStats.values.toList()
        ..sort(
          (a, b) => (b['productionCount'] as int).compareTo(
            a['productionCount'] as int,
          ),
        );

      final reportData = {
        'totalProductions': productionsData.length,
        'ongoingProductions': ongoingCount,
        'completedProductions': completedCount,
        'totalOutput': totalOutput,
        'totalWastage': totalWastage,
        'topRecipes': topRecipes.take(10).toList(),
      };

      return ReportModel(
        title: 'Production Summary Report',
        type: 'production_summary',
        generatedAt: DateTime.now(),
        data: reportData,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReportModel> generateMaterialUsageReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Get stock transactions within date range
      final response = await apiClient.get(ApiEndpoints.stock);
      final transactions = response.data['data'] as List<dynamic>;

      // Filter by date range
      final filteredTransactions = transactions.where((transaction) {
        final createdAt = DateTime.parse(transaction['created_at']);
        return createdAt.isAfter(startDate) && createdAt.isBefore(endDate);
      }).toList();

      // Calculate usage statistics
      final Map<String, Map<String, dynamic>> materialUsage = {};

      for (var transaction in filteredTransactions) {
        final materialId =
            transaction['material']?['_id'] ?? transaction['material'];
        if (materialId != null) {
          if (!materialUsage.containsKey(materialId)) {
            materialUsage[materialId] = {
              'materialId': materialId,
              'materialName': transaction['material']?['name'] ?? 'Unknown',
              'totalIn': 0.0,
              'totalOut': 0.0,
              'unit': transaction['material']?['unit'] ?? '',
            };
          }

          final quantity = (transaction['quantity'] ?? 0).toDouble();
          if (transaction['transaction_type'] == 'in') {
            materialUsage[materialId]!['totalIn'] =
                (materialUsage[materialId]!['totalIn'] as double) + quantity;
          } else {
            materialUsage[materialId]!['totalOut'] =
                (materialUsage[materialId]!['totalOut'] as double) + quantity;
          }
        }
      }

      final reportData = {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'materialUsage': materialUsage.values.toList(),
        'totalTransactions': filteredTransactions.length,
      };

      return ReportModel(
        title: 'Material Usage Report',
        type: 'material_usage',
        generatedAt: DateTime.now(),
        data: reportData,
      );
    } catch (e) {
      rethrow;
    }
  }
}
