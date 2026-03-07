// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MaterialHiveModelAdapter extends TypeAdapter<MaterialHiveModel> {
  @override
  final int typeId = 4;

  @override
  MaterialHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MaterialHiveModel(
      materialId: fields[0] as String?,
      name: fields[1] as String,
      unit: fields[2] as String,
      unitPrice: fields[3] as double,
      quantity: fields[4] as double,
      minimumStock: fields[5] as double,
      description: fields[6] as String?,
      userId: fields[7] as String?,
      createdAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MaterialHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.materialId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.unit)
      ..writeByte(3)
      ..write(obj.unitPrice)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.minimumStock)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.userId)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaterialHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
