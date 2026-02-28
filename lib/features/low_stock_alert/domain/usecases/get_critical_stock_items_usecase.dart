import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/low_stock_alert/domain/entities/low_stock_item_entity.dart';
import 'package:businesstrack/features/low_stock_alert/domain/repository/low_stock_alert_repository.dart';
import 'package:dartz/dartz.dart';

class GetCriticalStockItemsUsecase {
  final ILowStockAlertRepository repository;

  GetCriticalStockItemsUsecase(this.repository);

  Future<Either<Failure, List<LowStockItemEntity>>> call() {
    return repository.getCriticalStockItems();
  }
}
