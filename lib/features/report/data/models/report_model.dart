import 'package:businesstrack/features/report/domain/entities/report_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'report_model.g.dart';

@HiveType(typeId: 10)
class ReportModel extends HiveObject {
  @HiveField(0)
  final String? reportId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final Map<String, dynamic> data;

  @HiveField(4)
  final DateTime? generatedAt;

  @HiveField(5)
  final String? generatedBy;

  @HiveField(6)
  final DateTime? startDate;

  @HiveField(7)
  final DateTime? endDate;

  ReportModel({
    String? reportId,
    required this.title,
    required this.type,
    required this.data,
    this.generatedAt,
    this.generatedBy,
    this.startDate,
    this.endDate,
  }) : reportId = reportId ?? const Uuid().v4();

  factory ReportModel.fromEntity(ReportEntity entity) {
    return ReportModel(
      reportId: entity.reportId,
      title: entity.title,
      type: entity.type,
      data: entity.data,
      generatedAt: entity.generatedAt,
      generatedBy: entity.generatedBy,
      startDate: entity.startDate,
      endDate: entity.endDate,
    );
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      reportId: json['_id'] as String?,
      title: json['title'] as String,
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>,
      generatedAt: json['generatedAt'] != null
          ? DateTime.parse(json['generatedAt'] as String)
          : null,
      generatedBy: json['generatedBy'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'data': data,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  ReportEntity toEntity() {
    return ReportEntity(
      reportId: reportId,
      title: title,
      type: type,
      data: data,
      generatedAt: generatedAt,
      generatedBy: generatedBy,
      startDate: startDate,
      endDate: endDate,
    );
  }

  static List<ReportEntity> toEntityList(List<ReportModel> list) {
    return list.map((e) => e.toEntity()).toList();
  }
}
