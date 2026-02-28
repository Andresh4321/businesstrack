import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/low_stock_alert/domain/entities/low_stock_alert_entity.dart';
import 'package:businesstrack/features/low_stock_alert/domain/repositories/low_stock_alert_repository.dart';
import 'package:dartz/dartz.dart';

class CheckLowStockItemsUseCase {
  final ILowStockAlertRepository _repository;

  CheckLowStockItemsUseCase(this._repository);

  Future<Either<Failure, List<LowStockAlertEntity>>> call() async {
    return await _repository.checkLowStockItems();
  }
}
