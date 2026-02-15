// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SupplierHiveModelAdapter extends TypeAdapter<SupplierHiveModel> {
  @override
  final int typeId = 3;

  @override
  SupplierHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SupplierHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      contactName: fields[3] as String,
      productNames: (fields[4] as List).cast<String>(),
      userId: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SupplierHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.contactName)
      ..writeByte(4)
      ..write(obj.productNames)
      ..writeByte(5)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplierHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
