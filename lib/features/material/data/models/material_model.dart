import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'material_model.g.dart';

@HiveType(typeId: 4) // Updated to match HiveTableConstant.materialTypeId
class MaterialModel extends HiveObject {
  @HiveField(0)
  final String? materialId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String unit;

  @HiveField(3)
  final double unitPrice;

  @HiveField(4)
  final double quantity; // Actual current stock

  @HiveField(5)
  final double minimumStock;

  @HiveField(6)
  final String? description;

  @HiveField(7)
  final String? userId;

  @HiveField(8)
  final DateTime? createdAt;

  @HiveField(9)
  final DateTime? updatedAt;

  MaterialModel({
    String? materialId,
    required this.name,
    required this.unit,
    required this.unitPrice,
    required this.quantity,
    required this.minimumStock,
    this.description,
    this.userId,
    this.createdAt,
    this.updatedAt,
  }) : materialId = materialId ?? const Uuid().v4();

  /// From Entity
  factory MaterialModel.fromEntity(MaterialEntity entity) {
    return MaterialModel(
      materialId: entity.materialId,
      name: entity.name,
      unit: entity.unit,
      unitPrice: entity.unitPrice,
      quantity: entity.quantity,
      minimumStock: entity.minimumStock,
      description: entity.description,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// From JSON (Backend API response)
  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    final rawUser = json['user'];
    String? parsedUserId;
    if (rawUser is String) {
      parsedUserId = rawUser;
    } else if (rawUser is Map<String, dynamic>) {
      parsedUserId = rawUser['_id'] as String?;
    }

    return MaterialModel(
      materialId: json['_id'] as String?,
      name: (json['name'] ?? '') as String,
      unit: (json['unit'] ?? '') as String,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      minimumStock: (json['minimum_stock'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String?,
      userId: parsedUserId,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// To JSON (For API requests)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unit': unit,
      'unit_price': unitPrice,
      'minimum_stock': minimumStock,
      'description': description,
    };
  }

  /// To Entity
  MaterialEntity toEntity() {
    return MaterialEntity(
      materialId: materialId,
      name: name,
      unit: unit,
      unitPrice: unitPrice,
      quantity: quantity,
      minimumStock: minimumStock,
      description: description,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert List
  static List<MaterialEntity> toEntityList(List<MaterialModel> list) {
    return list.map((e) => e.toEntity()).toList();
  }
}
