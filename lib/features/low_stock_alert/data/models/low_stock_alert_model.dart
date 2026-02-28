import 'package:businesstrack/features/low_stock_alert/domain/entities/low_stock_alert_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'low_stock_alert_model.g.dart';

@HiveType(typeId: 11)
class LowStockAlertModel extends HiveObject {
  @HiveField(0)
  final String? alertId;

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

  LowStockAlertModel({
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

  factory LowStockAlertModel.fromEntity(LowStockAlertEntity entity) {
    return LowStockAlertModel(
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

  factory LowStockAlertModel.fromJson(Map<String, dynamic> json) {
    return LowStockAlertModel(
      alertId: json['_id'] as String?,
      materialId: json['material'] is Map
          ? json['material']['_id'] as String
          : json['material'] as String,
      materialName: json['materialName'] as String,
      currentQuantity: (json['currentQuantity'] as num).toDouble(),
      thresholdQuantity: (json['thresholdQuantity'] as num).toDouble(),
      severity: json['severity'] as String,
      isResolved: json['isResolved'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      resolvedBy: json['resolvedBy'] as String?,
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'material': materialId,
      'materialName': materialName,
      'currentQuantity': currentQuantity,
      'thresholdQuantity': thresholdQuantity,
      'severity': severity,
      'isResolved': isResolved,
    };
  }

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

  static List<LowStockAlertEntity> toEntityList(List<LowStockAlertModel> list) {
    return list.map((e) => e.toEntity()).toList();
  }
}
