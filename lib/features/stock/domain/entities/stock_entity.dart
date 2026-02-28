import 'package:equatable/equatable.dart';

class StockEntity extends Equatable {
  final String? stockId;
  final String materialId;
  final double quantity;
  final String transactionType; // 'in' or 'out'
  final String? description;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StockEntity({
    this.stockId,
    required this.materialId,
    required this.quantity,
    required this.transactionType,
    this.description,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    stockId,
    materialId,
    quantity,
    transactionType,
    description,
    userId,
    createdAt,
    updatedAt,
  ];
}
