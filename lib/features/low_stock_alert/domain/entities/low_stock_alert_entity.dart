import 'package:equatable/equatable.dart';

class LowStockAlertEntity extends Equatable {
  final String? alertId;
  final String materialId;
  final String materialName;
  final double currentQuantity;
  final double thresholdQuantity;
  final String severity; // 'critical', 'warning', 'info'
  final bool isResolved;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? resolvedBy;
  final DateTime? resolvedAt;

  const LowStockAlertEntity({
    this.alertId,
    required this.materialId,
    required this.materialName,
    required this.currentQuantity,
    required this.thresholdQuantity,
    required this.severity,
    this.isResolved = false,
    this.createdAt,
    this.updatedAt,
    this.resolvedBy,
    this.resolvedAt,
  });

  @override
  List<Object?> get props => [
    alertId,
    materialId,
    materialName,
    currentQuantity,
    thresholdQuantity,
    severity,
    isResolved,
    createdAt,
    updatedAt,
    resolvedBy,
    resolvedAt,
  ];
}
