import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'production_hive_model.g.dart';

@HiveType(typeId: 10)
class ProductionItemHiveModel extends HiveObject {
  @HiveField(0)
  final String itemId;

  @HiveField(1)
  final String materialId;

  @HiveField(2)
  final double quantityUsed;

  @HiveField(3)
  final String unit;

  ProductionItemHiveModel({
    String? itemId,
    required this.materialId,
    required this.quantityUsed,
    required this.unit,
  }) : itemId = itemId ?? const Uuid().v4();

  ProductionItemEntity toEntity() {
    return ProductionItemEntity(
      itemId: itemId,
      materialId: materialId,
      quantityUsed: quantityUsed,
      unit: unit,
    );
  }

  factory ProductionItemHiveModel.fromEntity(ProductionItemEntity entity) {
    return ProductionItemHiveModel(
      itemId: entity.itemId,
      materialId: entity.materialId,
      quantityUsed: entity.quantityUsed,
      unit: entity.unit,
    );
  }
}

@HiveType(typeId: 9)
class ProductionHiveModel extends HiveObject {
  @HiveField(0)
  final String productionId;

  @HiveField(1)
  final String recipeId;

  @HiveField(2)
  final double batchQuantity;

  @HiveField(3)
  final double estimatedOutput;

  @HiveField(4)
  final double? actualOutput;

  @HiveField(5)
  final double wastage;

  @HiveField(6)
  final List<ProductionItemHiveModel> itemsUsed;

  @HiveField(7)
  final String status;

  @HiveField(8)
  final String? userId;

  @HiveField(9)
  final DateTime? createdAt;

  @HiveField(10)
  final DateTime? updatedAt;

  ProductionHiveModel({
    String? productionId,
    required this.recipeId,
    required this.batchQuantity,
    required this.estimatedOutput,
    this.actualOutput,
    this.wastage = 0,
    required this.itemsUsed,
    required this.status,
    this.userId,
    this.createdAt,
    this.updatedAt,
  }) : productionId = productionId ?? const Uuid().v4();

  // To Entity
  ProductionEntity toEntity() {
    return ProductionEntity(
      productionId: productionId,
      recipeId: recipeId,
      batchQuantity: batchQuantity,
      estimatedOutput: estimatedOutput,
      actualOutput: actualOutput,
      wastage: wastage,
      itemsUsed: itemsUsed.map((e) => e.toEntity()).toList(),
      status: status,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // From Entity
  factory ProductionHiveModel.fromEntity(ProductionEntity entity) {
    return ProductionHiveModel(
      productionId: entity.productionId,
      recipeId: entity.recipeId,
      batchQuantity: entity.batchQuantity,
      estimatedOutput: entity.estimatedOutput,
      actualOutput: entity.actualOutput,
      wastage: entity.wastage,
      itemsUsed: entity.itemsUsed
          .map((e) => ProductionItemHiveModel.fromEntity(e))
          .toList(),
      status: entity.status,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Convert list
  static List<ProductionEntity> toEntityList(List<ProductionHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
