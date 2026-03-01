import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/report/domain/entities/report_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IReportRepository {
  Future<Either<Failure, List<ReportEntity>>> getAllReports();
  Future<Either<Failure, ReportEntity>> getReportById(String reportId);
  Future<Either<Failure, ReportEntity>> generateReport({
    required String title,
    required String type,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<Either<Failure, bool>> deleteReport(String reportId);
  Future<Either<Failure, bool>> saveReport(ReportEntity report);
}
