import 'package:equatable/equatable.dart';

class ReportEntity extends Equatable {
  final String? reportId;
  final String title;
  final String type; // 'production', 'inventory', 'sales', etc.
  final Map<String, dynamic> data;
  final DateTime? generatedAt;
  final String? generatedBy;
  final DateTime? startDate;
  final DateTime? endDate;

  const ReportEntity({
    this.reportId,
    required this.title,
    required this.type,
    required this.data,
    this.generatedAt,
    this.generatedBy,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
    reportId,
    title,
    type,
    data,
    generatedAt,
    generatedBy,
    startDate,
    endDate,
  ];
}
