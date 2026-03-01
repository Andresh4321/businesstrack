import 'package:businesstrack/features/report/data/models/report_model.dart';

abstract interface class IReportRemoteDataSource {
  Future<List<ReportModel>> getAllReports();
  Future<ReportModel> getReportById(String reportId);
  Future<ReportModel> generateReport({
    required String title,
    required String type,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<bool> deleteReport(String reportId);
}
