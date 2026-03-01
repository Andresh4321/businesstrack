import 'package:equatable/equatable.dart';

class ProductionItemEntity extends Equatable {
  final String? itemId;
  final String materialId;
  final double quantityUsed;
  final String unit;

  const ProductionItemEntity({
    this.itemId,
    required this.materialId,
    required this.quantityUsed,
    required this.unit,
  });

  @override
  List<Object?> get props => [itemId, materialId, quantityUsed, unit];
}

class ProductionEntity extends Equatable {
  final String? productionId;
  final String recipeId;
  final double batchQuantity;
  final double estimatedOutput;
  final double? actualOutput;
  final double wastage;
  final List<ProductionItemEntity> itemsUsed;
  final String status; // 'ongoing' or 'completed'
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductionEntity({
    this.productionId,
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
  });

  @override
  List<Object?> get props => [
    productionId,
    recipeId,
    batchQuantity,
    estimatedOutput,
    actualOutput,
    wastage,
    itemsUsed,
    status,
    userId,
    createdAt,
    updatedAt,
  ];
}
