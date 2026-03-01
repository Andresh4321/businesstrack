import 'package:businesstrack/core/constants/hive_table_constant.dart';
import 'package:businesstrack/features/report/data/datasources/report_datasource.dart';
import 'package:businesstrack/features/report/data/models/report_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final reportLocalDatasourceProvider = Provider<IReportDataSource>((ref) {
  return ReportLocalDataSource();
});

class ReportLocalDataSource implements IReportDataSource {
  ReportLocalDataSource();

  Box<ReportModel> get _reportBox =>
      Hive.box<ReportModel>(HiveTableConstant.reportBox);

  @override
  Future<List<ReportModel>> getAllReports() async {
    try {
      final reports = _reportBox.values.toList();
      return reports;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReportModel> getReportById(String reportId) async {
    try {
      final report = _reportBox.values.firstWhere(
        (report) => report.reportId == reportId,
      );
      return report;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> saveReport(ReportModel report) async {
    try {
      await _reportBox.put(report.reportId, report);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteReport(String reportId) async {
    try {
      await _reportBox.delete(reportId);
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
