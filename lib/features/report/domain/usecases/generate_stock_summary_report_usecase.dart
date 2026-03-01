import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/report/domain/entities/report_entity.dart';
import 'package:businesstrack/features/report/domain/repository/report_repository.dart';
import 'package:dartz/dartz.dart';

class GenerateStockSummaryReportUsecase {
  final IReportRepository repository;

  GenerateStockSummaryReportUsecase(this.repository);

  Future<Either<Failure, ReportEntity>> call() {
    return repository.generateStockSummaryReport();
  }
}
