import 'package:equatable/equatable.dart';

class BillOfMaterialsEntity extends Equatable {
  final String? billId;
  final String materialId;
  final double quantity;
  final double price;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BillOfMaterialsEntity({
    this.billId,
    required this.materialId,
    required this.quantity,
    required this.price,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    billId,
    materialId,
    quantity,
    price,
    userId,
    createdAt,
    updatedAt,
  ];
}
