import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';

class SupplierApiModel {
  final String? id;
  final String name;
  final String email;
  final String contactNumber;
  final List<String> products;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SupplierApiModel({
    this.id,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.products,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  // Convert JSON → API Model
  factory SupplierApiModel.fromJson(Map<String, dynamic> json) {
    return SupplierApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      contactNumber: json['contact_number'] as String,
      products: List<String>.from(json['products'] as List<dynamic>? ?? []),
      userId: json['user'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // Convert API Model → JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "contact_number": contactNumber,
      "products": products,
    };
  }

  // Convert API Model → Entity
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

  // Convert Entity → API Model
  factory SupplierApiModel.fromEntity(SupplierEntity entity) {
    return SupplierApiModel(
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
}
