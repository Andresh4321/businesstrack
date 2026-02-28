// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'low_stock_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LowStockItemModelAdapter extends TypeAdapter<LowStockItemModel> {
  @override
  final int typeId = 11;

  @override
  LowStockItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LowStockItemModel(
      materialId: fields[0] as String,
      materialName: fields[1] as String,
      unit: fields[2] as String,
      unitPrice: fields[3] as double,
      currentQuantity: fields[4] as double,
      minimumStock: fields[5] as double,
      description: fields[6] as String?,
      lastUpdated: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LowStockItemModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.materialId)
      ..writeByte(1)
      ..write(obj.materialName)
      ..writeByte(2)
      ..write(obj.unit)
      ..writeByte(3)
      ..write(obj.unitPrice)
      ..writeByte(4)
      ..write(obj.currentQuantity)
      ..writeByte(5)
      ..write(obj.minimumStock)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LowStockItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
