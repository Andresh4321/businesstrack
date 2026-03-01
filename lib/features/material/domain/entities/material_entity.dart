import 'package:equatable/equatable.dart';

class MaterialEntity extends Equatable {
  final String? materialId;
  final String name;
  final String unit;
  final double unitPrice;
  final double quantity; // Actual current stock
  final double minimumStock;
  final String? description;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MaterialEntity({
    this.materialId,
    required this.name,
    required this.unit,
    required this.unitPrice,
    required this.quantity,
    required this.minimumStock,
    this.description,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  MaterialEntity copyWith({
    String? materialId,
    String? name,
    String? unit,
    double? unitPrice,
    double? quantity,
    double? minimumStock,
    String? description,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MaterialEntity(
      materialId: materialId ?? this.materialId,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      minimumStock: minimumStock ?? this.minimumStock,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    materialId,
    name,
    unit,
    unitPrice,
    quantity,
    minimumStock,
    description,
    userId,
    createdAt,
    updatedAt,
  ];
}
