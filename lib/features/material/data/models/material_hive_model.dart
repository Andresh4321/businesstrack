import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'material_hive_model.g.dart';

@HiveType(typeId: 4)
class MaterialHiveModel extends HiveObject {
  @HiveField(0)
  final String materialId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String unit;

  @HiveField(3)
  final double unitPrice;

  @HiveField(4)
  final double quantity;

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

  MaterialHiveModel({
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

  // To Entity
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

  // From Entity
  factory MaterialHiveModel.fromEntity(MaterialEntity entity) {
    return MaterialHiveModel(
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

  // Convert list
  static List<MaterialEntity> toEntityList(List<MaterialHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
