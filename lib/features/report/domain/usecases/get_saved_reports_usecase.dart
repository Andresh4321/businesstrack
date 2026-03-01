import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/report/domain/entities/report_entity.dart';
import 'package:businesstrack/features/report/domain/repository/report_repository.dart';
import 'package:dartz/dartz.dart';

class GetSavedReportsUsecase {
  final IReportRepository repository;

  GetSavedReportsUsecase(this.repository);

  Future<Either<Failure, List<ReportEntity>>> call() {
    return repository.getSavedReports();
  }
}
