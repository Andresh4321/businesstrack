import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';
import 'package:hive/hive.dart';

part 'supplier_hive_model.g.dart';

@HiveType(typeId: 3) // Matches HiveTableConstant.supplierTypeId
class SupplierHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String contactNumber;

  @HiveField(4)
  final List<String> products;

  @HiveField(5)
  final String? userId;

  @HiveField(6)
  final DateTime? createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  SupplierHiveModel({
    this.id,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.products,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  /// From Entity
  factory SupplierHiveModel.fromEntity(SupplierEntity entity) {
    return SupplierHiveModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      contactNumber: entity.contactNumber,
      products: entity.products,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// To Entity
  SupplierEntity toEntity() {
    return SupplierEntity(
      id: id,
      name: name,
      email: email,
      contactNumber: contactNumber,
      products: products,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static List<SupplierEntity> toEntityList(List<SupplierHiveModel> list) {
    return list.map((e) => e.toEntity()).toList();
  }
}
