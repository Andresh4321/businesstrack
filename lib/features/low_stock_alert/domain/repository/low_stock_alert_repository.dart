import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/low_stock_alert/domain/entities/low_stock_item_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class ILowStockAlertRepository {
  /// Get all materials that are below minimum stock level
  Future<Either<Failure, List<LowStockItemEntity>>> getLowStockItems();
  
  /// Get critically low stock items (below 25% of minimum)
  Future<Either<Failure, List<LowStockItemEntity>>> getCriticalStockItems();
}
