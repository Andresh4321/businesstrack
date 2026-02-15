import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';

class SupplierApiModel {
  final String? id;
  final String name;
  final String email;
  final String contactName;
  final List<String> productNames;
  final String userId;

  SupplierApiModel({
    this.id,
    required this.name,
    required this.email,
    required this.contactName,
    required this.productNames,
    required this.userId,
  });

  // Convert JSON → API Model
  factory SupplierApiModel.fromJson(Map<String, dynamic> json) {
    return SupplierApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      contactName: json['contactName'] as String,
      productNames: List<String>.from(json['productNames'] as List<dynamic>),
      userId: json['userId'] as String,
    );
  }

  // Convert API Model → JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "contactName": contactName,
      "productNames": productNames,
      "userId": userId,
    };
  }

  // Convert API Model → Entity
  SupplierEntity toEntity() {
    return SupplierEntity(
      id: id ?? '',
      name: name,
      email: email,
      contactName: contactName,
      productNames: productNames,
      userId: userId,
    );
  }

  // Convert Entity → API Model
  factory SupplierApiModel.fromEntity(SupplierEntity entity) {
    return SupplierApiModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      contactName: entity.contactName,
      productNames: entity.productNames,
      userId: entity.userId,
    );
  }
}
