import 'package:businesstrack/features/bill_of_materials/domain/entities/bill_of_materials_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'bill_of_materials_model.g.dart';

@HiveType(typeId: 6) // Matches HiveTableConstant.billOfMaterialsTypeId
class BillOfMaterialsModel extends HiveObject {
  @HiveField(0)
  final String? billId;

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

  BillOfMaterialsModel({
    String? billId,
    required this.materialId,
    required this.quantity,
    required this.price,
    this.userId,
    this.createdAt,
    this.updatedAt,
  }) : billId = billId ?? const Uuid().v4();

  /// From Entity
  factory BillOfMaterialsModel.fromEntity(BillOfMaterialsEntity entity) {
    return BillOfMaterialsModel(
      billId: entity.billId,
      materialId: entity.materialId,
      quantity: entity.quantity,
      price: entity.price,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// From JSON (Backend API response)
  factory BillOfMaterialsModel.fromJson(Map<String, dynamic> json) {
    return BillOfMaterialsModel(
      billId: json['_id'] as String?,
      materialId: json['material'] is Map
          ? json['material']['_id'] as String
          : json['material'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      userId: json['user'] as String?,
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
    return {'material': materialId, 'quantity': quantity, 'price': price};
  }

  /// To Entity
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

  /// Convert List
  static List<BillOfMaterialsEntity> toEntityList(
    List<BillOfMaterialsModel> list,
  ) {
    return list.map((e) => e.toEntity()).toList();
  }
}
