import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/low_stock_alert/domain/entities/low_stock_alert_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class ILowStockAlertRepository {
  Future<Either<Failure, List<LowStockAlertEntity>>> getAllAlerts();
  Future<Either<Failure, List<LowStockAlertEntity>>> getUnresolvedAlerts();
  Future<Either<Failure, LowStockAlertEntity>> getAlertById(String alertId);
  Future<Either<Failure, bool>> createAlert(LowStockAlertEntity alert);
  Future<Either<Failure, bool>> resolveAlert(String alertId, String resolvedBy);
  Future<Either<Failure, bool>> deleteAlert(String alertId);
  Future<Either<Failure, List<LowStockAlertEntity>>> checkLowStockItems();
}
