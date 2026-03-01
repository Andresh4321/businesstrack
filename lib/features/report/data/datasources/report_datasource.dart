import 'package:businesstrack/features/report/data/models/report_model.dart';

abstract interface class IReportDataSource {
  Future<List<ReportModel>> getAllReports();
  Future<ReportModel> getReportById(String reportId);
  Future<bool> saveReport(ReportModel report);
  Future<bool> deleteReport(String reportId);
}
