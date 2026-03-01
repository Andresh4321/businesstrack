import 'package:businesstrack/features/report/data/models/report_model.dart';

abstract interface class IReportDataSource {
  Future<ReportModel> generateStockSummaryReport();
  Future<ReportModel> generateProductionSummaryReport();
  Future<ReportModel> generateMaterialUsageReport({
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<List<ReportModel>> getSavedReports();
  Future<bool> saveReport(ReportModel report);
  Future<bool> deleteReport(String reportId);
}

abstract interface class IReportRemoteDataSource {
  Future<ReportModel> generateStockSummaryReport();
  Future<ReportModel> generateProductionSummaryReport();
  Future<ReportModel> generateMaterialUsageReport({
    required DateTime startDate,
    required DateTime endDate,
  });
}

abstract interface class IReportLocalDataSource {
  Future<List<ReportModel>> getSavedReports();
  Future<bool> saveReport(ReportModel report);
  Future<bool> deleteReport(String reportId);
}
