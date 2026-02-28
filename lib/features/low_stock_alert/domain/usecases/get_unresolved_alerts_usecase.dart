import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/low_stock_alert/domain/entities/low_stock_alert_entity.dart';
import 'package:businesstrack/features/low_stock_alert/domain/repositories/low_stock_alert_repository.dart';
import 'package:dartz/dartz.dart';

class GetUnresolvedAlertsUseCase {
  final ILowStockAlertRepository _repository;

  GetUnresolvedAlertsUseCase(this._repository);

  Future<Either<Failure, List<LowStockAlertEntity>>> call() async {
    return await _repository.getUnresolvedAlerts();
  }
}
