import 'package:businesstrack/core/constants/hive_table_constant.dart';
import 'package:businesstrack/features/report/data/datasource/report_datasource.dart';
import 'package:businesstrack/features/report/data/models/report_model.dart';
import 'package:hive/hive.dart';

class ReportLocalDataSource implements IReportLocalDataSource {
  @override
  Future<List<ReportModel>> getSavedReports() async {
    try {
      final box = await Hive.openBox<ReportModel>(
        HiveTableConstant.reportBox,
      );
      return box.values.toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> saveReport(ReportModel report) async {
    try {
      final box = await Hive.openBox<ReportModel>(
        HiveTableConstant.reportBox,
      );
      await box.put(report.reportId, report);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteReport(String reportId) async {
    try {
      final box = await Hive.openBox<ReportModel>(
        HiveTableConstant.reportBox,
      );
      await box.delete(reportId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
