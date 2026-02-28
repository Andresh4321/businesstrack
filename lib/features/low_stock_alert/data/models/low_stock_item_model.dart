import 'package:businesstrack/features/low_stock_alert/domain/entities/low_stock_item_entity.dart';
import 'package:hive/hive.dart';

part 'low_stock_item_model.g.dart';

@HiveType(typeId: 11) // Using typeId 11 for low stock items (matches HiveTableConstant.lowStockAlertTypeId)
class LowStockItemModel extends HiveObject {
  @HiveField(0)
  final String materialId;

  @HiveField(1)
  final String materialName;

  @HiveField(2)
  final String unit;

  @HiveField(3)
  final double unitPrice;

  @HiveField(4)
  final double currentQuantity;

  @HiveField(5)
  final double minimumStock;

  @HiveField(6)
  final String? description;

  @HiveField(7)
  final DateTime? lastUpdated;

  LowStockItemModel({
    required this.materialId,
    required this.materialName,
    required this.unit,
    required this.unitPrice,
    required this.currentQuantity,
    required this.minimumStock,
    this.description,
    this.lastUpdated,
  });

  // Convert from Entity
  factory LowStockItemModel.fromEntity(LowStockItemEntity entity) {
    return LowStockItemModel(
      materialId: entity.materialId,
      materialName: entity.materialName,
      unit: entity.unit,
      unitPrice: entity.unitPrice,
      currentQuantity: entity.currentQuantity,
      minimumStock: entity.minimumStock,
      description: entity.description,
      lastUpdated: entity.lastUpdated,
    );
  }

  // Convert to Entity
  LowStockItemEntity toEntity() {
    return LowStockItemEntity(
      materialId: materialId,
      materialName: materialName,
      unit: unit,
      unitPrice: unitPrice,
      currentQuantity: currentQuantity,
      minimumStock: minimumStock,
      description: description,
      lastUpdated: lastUpdated,
    );
  }

  // From JSON (API response)
  // The backend returns stock data with populated material info
  factory LowStockItemModel.fromJson(Map<String, dynamic> json) {
    final material = json['material'] as Map<String, dynamic>?;
    
    return LowStockItemModel(
      materialId: material?['_id'] ?? json['material'].toString(),
      materialName: material?['name'] ?? '',
      unit: material?['unit'] ?? '',
      unitPrice: (material?['unit_price'] ?? 0).toDouble(),
      currentQuantity: (json['quantity'] ?? 0).toDouble(),
      minimumStock: (material?['minimum_stock'] ?? 0).toDouble(),
      description: material?['description'],
      lastUpdated: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : json['created_at'] != null 
              ? DateTime.parse(json['created_at'])
              : null,
    );
  }

  // To JSON (for API requests if needed)
  Map<String, dynamic> toJson() {
    return {
      'material_id': materialId,
      'material_name': materialName,
      'unit': unit,
      'unit_price': unitPrice,
      'current_quantity': currentQuantity,
      'minimum_stock': minimumStock,
      'description': description,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }
}
