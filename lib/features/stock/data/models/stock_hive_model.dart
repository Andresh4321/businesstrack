import 'package:businesstrack/features/stock/domain/entities/stock_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'stock_hive_model.g.dart';

@HiveType(typeId: 5)
class StockHiveModel extends HiveObject {
  @HiveField(0)
  final String stockId;

  @HiveField(1)
  final String materialId;

  @HiveField(2)
  final double quantity;

  @HiveField(3)
  final String transactionType;

  @HiveField(4)
  final String? description;

  @HiveField(5)
  final String? userId;

  @HiveField(6)
  final DateTime? createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  StockHiveModel({
    String? stockId,
    required this.materialId,
    required this.quantity,
    required this.transactionType,
    this.description,
    this.userId,
    this.createdAt,
    this.updatedAt,
  }) : stockId = stockId ?? const Uuid().v4();

  // To Entity
  StockEntity toEntity() {
    return StockEntity(
      stockId: stockId,
      materialId: materialId,
      quantity: quantity,
      transactionType: transactionType,
      description: description,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // From Entity
  factory StockHiveModel.fromEntity(StockEntity entity) {
    return StockHiveModel(
      stockId: entity.stockId,
      materialId: entity.materialId,
      quantity: entity.quantity,
      transactionType: entity.transactionType,
      description: entity.description,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Convert list
  static List<StockEntity> toEntityList(List<StockHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
