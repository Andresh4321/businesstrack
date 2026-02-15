import 'package:equatable/equatable.dart';

class SupplierEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String contactName;
  final List<String> productNames;
  final String userId;

  SupplierEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.contactName,
    required this.productNames,
    required this.userId,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    contactName,
    productNames,
    userId,
  ];
}
