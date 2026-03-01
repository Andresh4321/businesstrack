import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'production_model.g.dart';

@HiveType(typeId: 9) // Updated to match HiveTableConstant.productionTypeId
class ProductionItemModel extends HiveObject {
  @HiveField(0)
  final String? itemId;

  @HiveField(1)
  final String materialId;

  @HiveField(2)
  final double quantityUsed;

  @HiveField(3)
  final String unit;

  ProductionItemModel({
    String? itemId,
    required this.materialId,
    required this.quantityUsed,
    required this.unit,
  }) : itemId = itemId ?? const Uuid().v4();

  factory ProductionItemModel.fromEntity(ProductionItemEntity entity) {
    return ProductionItemModel(
      itemId: entity.itemId,
      materialId: entity.materialId,
      quantityUsed: entity.quantityUsed,
      unit: entity.unit,
    );
  }

  factory ProductionItemModel.fromJson(Map<String, dynamic> json) {
    return ProductionItemModel(
      itemId: json['_id'] as String?,
      materialId: json['material'] is Map
          ? json['material']['_id'] as String
          : json['material'] as String,
      quantityUsed: (json['quantityUsed'] as num).toDouble(),
      unit: json['unit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'material': materialId, 'quantityUsed': quantityUsed, 'unit': unit};
  }

  ProductionItemEntity toEntity() {
    return ProductionItemEntity(
      itemId: itemId,
      materialId: materialId,
      quantityUsed: quantityUsed,
      unit: unit,
    );
  }
}

@HiveType(typeId: 10) // Separate type ID for ProductionModel
class ProductionModel extends HiveObject {
  @HiveField(0)
  final String? productionId;

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
  final List<ProductionItemModel> itemsUsed;

  @HiveField(7)
  final String status;

  @HiveField(8)
  final String? userId;

  @HiveField(9)
  final DateTime? createdAt;

  @HiveField(10)
  final DateTime? updatedAt;

  ProductionModel({
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

  factory ProductionModel.fromEntity(ProductionEntity entity) {
    return ProductionModel(
      productionId: entity.productionId,
      recipeId: entity.recipeId,
      batchQuantity: entity.batchQuantity,
      estimatedOutput: entity.estimatedOutput,
      actualOutput: entity.actualOutput,
      wastage: entity.wastage,
      itemsUsed: entity.itemsUsed
          .map((e) => ProductionItemModel.fromEntity(e))
          .toList(),
      status: entity.status,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory ProductionModel.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['itemsUsed'] as List? ?? []);
    return ProductionModel(
      productionId: json['_id'] as String?,
      recipeId: json['recipe'] is Map
          ? json['recipe']['_id'] as String
          : (json['recipeId'] ?? json['recipe']) as String,
      batchQuantity: (json['batchQuantity'] as num).toDouble(),
      estimatedOutput: (json['estimatedOutput'] as num).toDouble(),
      actualOutput: json['actualOutput'] != null
          ? (json['actualOutput'] as num).toDouble()
          : null,
      wastage: (json['wastage'] as num?)?.toDouble() ?? 0,
      itemsUsed: itemsList
          .map(
            (item) =>
                ProductionItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      status: json['status'] as String,
      userId: json['user'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'batchQuantity': batchQuantity,
      'estimatedOutput': estimatedOutput,
      'actualOutput': actualOutput,
      'wastage': wastage,
      'itemsUsed': itemsUsed.map((e) => e.toJson()).toList(),
    };
  }

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

  static List<ProductionEntity> toEntityList(List<ProductionModel> list) {
    return list.map((e) => e.toEntity()).toList();
  }
}
