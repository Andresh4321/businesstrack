import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';
import 'package:hive/hive.dart';

part 'supplier_hive_model.g.dart';

@HiveType(typeId: 3)
class SupplierHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String contactName;

  @HiveField(4)
  final List<String> productNames;

  @HiveField(5)
  final String userId;

  SupplierHiveModel({
    required this.id,
    required this.name,
    required this.email,
    required this.contactName,
    required this.productNames,
    required this.userId,
  });

  /// From Entity
  factory SupplierHiveModel.fromEntity(SupplierEntity entity) {
    return SupplierHiveModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      contactName: entity.contactName,
      productNames: entity.productNames,
      userId: entity.userId,
    );
  }

  /// To Entity
  SupplierEntity toEntity() {
    return SupplierEntity(
      id: id,
      name: name,
      email: email,
      contactName: contactName,
      productNames: productNames,
      userId: userId,
    );
  }

  static List<SupplierEntity> toEntityList(List<SupplierHiveModel> list) {
    return list.map((e) => e.toEntity()).toList();
  }
}
