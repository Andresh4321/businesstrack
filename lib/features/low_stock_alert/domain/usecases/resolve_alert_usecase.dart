import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/low_stock_alert/domain/repositories/low_stock_alert_repository.dart';
import 'package:dartz/dartz.dart';

class ResolveAlertUseCase {
  final ILowStockAlertRepository _repository;

  ResolveAlertUseCase(this._repository);

  Future<Either<Failure, bool>> call(String alertId, String resolvedBy) async {
    return await _repository.resolveAlert(alertId, resolvedBy);
  }
}
