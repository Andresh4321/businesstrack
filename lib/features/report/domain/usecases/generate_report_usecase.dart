import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/report/domain/entities/report_entity.dart';
import 'package:businesstrack/features/report/domain/repositories/report_repository.dart';
import 'package:dartz/dartz.dart';

class GenerateReportUseCase {
  final IReportRepository _repository;

  GenerateReportUseCase(this._repository);

  Future<Either<Failure, ReportEntity>> call({
    required String title,
    required String type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _repository.generateReport(
      title: title,
      type: type,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
