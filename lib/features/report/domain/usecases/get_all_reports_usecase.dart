import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/report/domain/entities/report_entity.dart';
import 'package:businesstrack/features/report/domain/repositories/report_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllReportsUseCase {
  final IReportRepository _repository;

  GetAllReportsUseCase(this._repository);

  Future<Either<Failure, List<ReportEntity>>> call() async {
    return await _repository.getAllReports();
  }
}
