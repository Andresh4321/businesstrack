import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/report/domain/entities/report_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IReportRepository {
  /// Generate stock summary report
  Future<Either<Failure, ReportEntity>> generateStockSummaryReport();
  
  /// Generate production summary report
  Future<Either<Failure, ReportEntity>> generateProductionSummaryReport();
  
  /// Generate material usage report
  Future<Either<Failure, ReportEntity>> generateMaterialUsageReport({
    required DateTime startDate,
    required DateTime endDate,
  });
  
  /// Get saved reports
  Future<Either<Failure, List<ReportEntity>>> getSavedReports();
  
  /// Save a report
  Future<Either<Failure, bool>> saveReport(ReportEntity report);
  
  /// Delete a report
  Future<Either<Failure, bool>> deleteReport(String reportId);
}
