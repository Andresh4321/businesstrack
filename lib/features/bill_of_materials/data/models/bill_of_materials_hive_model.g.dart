// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_of_materials_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillOfMaterialsHiveModelAdapter
    extends TypeAdapter<BillOfMaterialsHiveModel> {
  @override
  final int typeId = 6;

  @override
  BillOfMaterialsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BillOfMaterialsHiveModel(
      billId: fields[0] as String?,
      materialId: fields[1] as String,
      quantity: fields[2] as double,
      price: fields[3] as double,
      userId: fields[4] as String?,
      createdAt: fields[5] as DateTime?,
      updatedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, BillOfMaterialsHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.billId)
      ..writeByte(1)
      ..write(obj.materialId)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillOfMaterialsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
