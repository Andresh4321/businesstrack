import 'package:businesstrack/features/stock/domain/entities/stock_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'stock_model.g.dart';

@HiveType(typeId: 5) // Updated to match HiveTableConstant.stockTypeId
class StockModel extends HiveObject {
  @HiveField(0)
  final String? stockId;

  @HiveField(1)
  final String materialId;

  @HiveField(2)
  final double quantity;

  @HiveField(3)
  final String transactionType; // 'in' or 'out'

  @HiveField(4)
  final String? description;

  @HiveField(5)
  final String? userId;

  @HiveField(6)
  final DateTime? createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  StockModel({
    String? stockId,
    required this.materialId,
    required this.quantity,
    required this.transactionType,
    this.description,
    this.userId,
    this.createdAt,
    this.updatedAt,
  }) : stockId = stockId ?? const Uuid().v4();

  factory StockModel.fromEntity(StockEntity entity) {
    return StockModel(
      stockId: entity.stockId,
      materialId: entity.materialId,
      quantity: entity.quantity,
      transactionType: entity.transactionType,
      description: entity.description,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory StockModel.fromJson(Map<String, dynamic> json) {
    final materialId = _extractObjectId(json['material']) ?? '';
    final userId = _extractObjectId(json['user']);

    final transactionTypeRaw =
        json['transaction_type'] ?? json['transactionType'] ?? json['type'];
    final normalizedType =
        transactionTypeRaw?.toString().toLowerCase().trim() ?? 'in';
    final transactionType = normalizedType == 'out' ? 'out' : 'in';

    final createdAtRaw = json['createdAt'] ?? json['created_at'];
    final updatedAtRaw = json['updatedAt'] ?? json['updated_at'];

    return StockModel(
      stockId: _extractObjectId(json['_id']) ?? json['id']?.toString(),
      materialId: materialId,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      transactionType: transactionType,
      description: json['description']?.toString(),
      userId: userId,
      createdAt: _parseDate(createdAtRaw),
      updatedAt: _parseDate(updatedAtRaw),
    );
  }

  static String? _extractObjectId(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      return value;
    }

    if (value is Map<String, dynamic>) {
      final nestedId = value['_id'] ?? value['id'] ?? value['\$oid'];
      if (nestedId != null) {
        return nestedId.toString();
      }
    }

    return value.toString();
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    if (value is Map<String, dynamic>) {
      final dateValue = value['\$date'];
      if (dateValue != null) {
        return DateTime.tryParse(dateValue.toString());
      }
    }

    return DateTime.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'material': materialId,
      'quantity': quantity,
      'transaction_type': transactionType,
      'description': description,
    };
  }

  StockEntity toEntity() {
    return StockEntity(
      stockId: stockId,
      materialId: materialId,
      quantity: quantity,
      transactionType: transactionType,
      description: description,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static List<StockEntity> toEntityList(List<StockModel> list) {
    return list.map((e) => e.toEntity()).toList();
  }
}
