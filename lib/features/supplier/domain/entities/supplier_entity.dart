import 'package:equatable/equatable.dart';

class SupplierEntity extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String contactNumber;
  final List<String> products;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SupplierEntity({
    this.id,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.products,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    contactNumber,
    products,
    userId,
    createdAt,
    updatedAt,
  ];
}
