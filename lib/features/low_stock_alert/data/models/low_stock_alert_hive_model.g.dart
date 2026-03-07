// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'low_stock_alert_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LowStockAlertHiveModelAdapter
    extends TypeAdapter<LowStockAlertHiveModel> {
  @override
  final int typeId = 22;

  @override
  LowStockAlertHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LowStockAlertHiveModel(
      alertId: fields[0] as String?,
      materialId: fields[1] as String,
      materialName: fields[2] as String,
      currentQuantity: fields[3] as double,
      thresholdQuantity: fields[4] as double,
      severity: fields[5] as String,
      isResolved: fields[6] as bool,
      createdAt: fields[7] as DateTime?,
      updatedAt: fields[8] as DateTime?,
      resolvedBy: fields[9] as String?,
      resolvedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LowStockAlertHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.alertId)
      ..writeByte(1)
      ..write(obj.materialId)
      ..writeByte(2)
      ..write(obj.materialName)
      ..writeByte(3)
      ..write(obj.currentQuantity)
      ..writeByte(4)
      ..write(obj.thresholdQuantity)
      ..writeByte(5)
      ..write(obj.severity)
      ..writeByte(6)
      ..write(obj.isResolved)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.resolvedBy)
      ..writeByte(10)
      ..write(obj.resolvedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LowStockAlertHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
