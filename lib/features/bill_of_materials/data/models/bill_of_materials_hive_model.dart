import 'package:businesstrack/features/bill_of_materials/domain/entities/bill_of_materials_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'bill_of_materials_hive_model.g.dart';

@HiveType(typeId: 6)
class BillOfMaterialsHiveModel extends HiveObject {
  @HiveField(0)
  final String billId;

  @HiveField(1)
  final String materialId;

  @HiveField(2)
  final double quantity;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String? userId;

  @HiveField(5)
  final DateTime? createdAt;

  @HiveField(6)
  final DateTime? updatedAt;

  BillOfMaterialsHiveModel({
    String? billId,
    required this.materialId,
    required this.quantity,
    required this.price,
    this.userId,
    this.createdAt,
    this.updatedAt,
  }) : billId = billId ?? const Uuid().v4();

  // To Entity
  BillOfMaterialsEntity toEntity() {
    return BillOfMaterialsEntity(
      billId: billId,
      materialId: materialId,
      quantity: quantity,
      price: price,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // From Entity
  factory BillOfMaterialsHiveModel.fromEntity(BillOfMaterialsEntity entity) {
    return BillOfMaterialsHiveModel(
      billId: entity.billId,
      materialId: entity.materialId,
      quantity: entity.quantity,
      price: entity.price,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Convert list
  static List<BillOfMaterialsEntity> toEntityList(
    List<BillOfMaterialsHiveModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}
