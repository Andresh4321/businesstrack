// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_metrics_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DashboardMetricsHiveModelAdapter
    extends TypeAdapter<DashboardMetricsHiveModel> {
  @override
  final int typeId = 21;

  @override
  DashboardMetricsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardMetricsHiveModel(
      id: fields[0] as String,
      totalMaterials: fields[1] as int,
      totalProducts: fields[2] as int,
      lowStockItems: fields[3] as int,
      totalInventoryValue: fields[4] as double,
      lastUpdated: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DashboardMetricsHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.totalMaterials)
      ..writeByte(2)
      ..write(obj.totalProducts)
      ..writeByte(3)
      ..write(obj.lowStockItems)
      ..writeByte(4)
      ..write(obj.totalInventoryValue)
      ..writeByte(5)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardMetricsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
