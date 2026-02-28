import 'package:equatable/equatable.dart';

/// Represents a material with low stock status
class LowStockItemEntity extends Equatable {
  final String materialId;
  final String materialName;
  final String unit;
  final double unitPrice;
  final double currentQuantity;
  final double minimumStock;
  final String? description;
  final DateTime? lastUpdated;

  const LowStockItemEntity({
    required this.materialId,
    required this.materialName,
    required this.unit,
    required this.unitPrice,
    required this.currentQuantity,
    required this.minimumStock,
    this.description,
    this.lastUpdated,
  });

  /// Calculate the shortage amount
  double get shortage => minimumStock - currentQuantity;

  /// Calculate the shortage percentage
  double get shortagePercentage => 
      minimumStock > 0 ? ((minimumStock - currentQuantity) / minimumStock * 100) : 0;

  /// Check if stock is critically low (below 25% of minimum)
  bool get isCritical => currentQuantity < (minimumStock * 0.25);

  @override
  List<Object?> get props => [
        materialId,
        materialName,
        unit,
        unitPrice,
        currentQuantity,
        minimumStock,
        description,
        lastUpdated,
      ];
}
