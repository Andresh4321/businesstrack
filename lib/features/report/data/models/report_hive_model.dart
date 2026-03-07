import 'package:businesstrack/features/report/domain/entities/report_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'report_hive_model.g.dart';

@HiveType(typeId: 27)
class ReportHiveModel extends HiveObject {
  @HiveField(0)
  final String reportId;

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

  ReportHiveModel({
    String? reportId,
    required this.title,
    required this.type,
    required this.data,
    this.generatedAt,
    this.generatedBy,
    this.startDate,
    this.endDate,
  }) : reportId = reportId ?? const Uuid().v4();

  // To Entity
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

  // From Entity
  factory ReportHiveModel.fromEntity(ReportEntity entity) {
    return ReportHiveModel(
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

  // Convert list
  static List<ReportEntity> toEntityList(List<ReportHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
