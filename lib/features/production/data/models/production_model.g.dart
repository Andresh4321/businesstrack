// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductionItemModelAdapter extends TypeAdapter<ProductionItemModel> {
  @override
  final int typeId = 9;

  @override
  ProductionItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductionItemModel(
      itemId: fields[0] as String?,
      materialId: fields[1] as String,
      quantityUsed: fields[2] as double,
      unit: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProductionItemModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.materialId)
      ..writeByte(2)
      ..write(obj.quantityUsed)
      ..writeByte(3)
      ..write(obj.unit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductionItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductionModelAdapter extends TypeAdapter<ProductionModel> {
  @override
  final int typeId = 10;

  @override
  ProductionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductionModel(
      productionId: fields[0] as String?,
      recipeId: fields[1] as String,
      batchQuantity: fields[2] as double,
      estimatedOutput: fields[3] as double,
      actualOutput: fields[4] as double?,
      wastage: fields[5] as double,
      itemsUsed: (fields[6] as List).cast<ProductionItemModel>(),
      status: fields[7] as String,
      userId: fields[8] as String?,
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductionModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.productionId)
      ..writeByte(1)
      ..write(obj.recipeId)
      ..writeByte(2)
      ..write(obj.batchQuantity)
      ..writeByte(3)
      ..write(obj.estimatedOutput)
      ..writeByte(4)
      ..write(obj.actualOutput)
      ..writeByte(5)
      ..write(obj.wastage)
      ..writeByte(6)
      ..write(obj.itemsUsed)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.userId)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
