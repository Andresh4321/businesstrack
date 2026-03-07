import 'package:businesstrack/features/low_stock_alert/domain/entities/low_stock_alert_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'low_stock_alert_hive_model.g.dart';

@HiveType(typeId: 22)
class LowStockAlertHiveModel extends HiveObject {
  @HiveField(0)
  final String alertId;

  @HiveField(1)
  final String materialId;

  @HiveField(2)
  final String materialName;

  @HiveField(3)
  final double currentQuantity;

  @HiveField(4)
  final double thresholdQuantity;

  @HiveField(5)
  final String severity;

  @HiveField(6)
  final bool isResolved;

  @HiveField(7)
  final DateTime? createdAt;

  @HiveField(8)
  final DateTime? updatedAt;

  @HiveField(9)
  final String? resolvedBy;

  @HiveField(10)
  final DateTime? resolvedAt;

  LowStockAlertHiveModel({
    String? alertId,
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
  }) : alertId = alertId ?? const Uuid().v4();

  // To Entity
  LowStockAlertEntity toEntity() {
    return LowStockAlertEntity(
      alertId: alertId,
      materialId: materialId,
      materialName: materialName,
      currentQuantity: currentQuantity,
      thresholdQuantity: thresholdQuantity,
      severity: severity,
      isResolved: isResolved,
      createdAt: createdAt,
      updatedAt: updatedAt,
      resolvedBy: resolvedBy,
      resolvedAt: resolvedAt,
    );
  }

  // From Entity
  factory LowStockAlertHiveModel.fromEntity(LowStockAlertEntity entity) {
    return LowStockAlertHiveModel(
      alertId: entity.alertId,
      materialId: entity.materialId,
      materialName: entity.materialName,
      currentQuantity: entity.currentQuantity,
      thresholdQuantity: entity.thresholdQuantity,
      severity: entity.severity,
      isResolved: entity.isResolved,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      resolvedBy: entity.resolvedBy,
      resolvedAt: entity.resolvedAt,
    );
  }

  // Convert list
  static List<LowStockAlertEntity> toEntityList(
    List<LowStockAlertHiveModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}
