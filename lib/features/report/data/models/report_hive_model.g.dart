// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportHiveModelAdapter extends TypeAdapter<ReportHiveModel> {
  @override
  final int typeId = 27;

  @override
  ReportHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportHiveModel(
      reportId: fields[0] as String?,
      title: fields[1] as String,
      type: fields[2] as String,
      data: (fields[3] as Map).cast<String, dynamic>(),
      generatedAt: fields[4] as DateTime?,
      generatedBy: fields[5] as String?,
      startDate: fields[6] as DateTime?,
      endDate: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ReportHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.reportId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.data)
      ..writeByte(4)
      ..write(obj.generatedAt)
      ..writeByte(5)
      ..write(obj.generatedBy)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
