import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/bill_of_materials/domain/entities/bill_of_materials_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IBillOfMaterialsRepository {
  Future<Either<Failure, List<BillOfMaterialsEntity>>> getAllBillItems();
  Future<Either<Failure, BillOfMaterialsEntity>> createBillItem(
    BillOfMaterialsEntity entity,
  );
  Future<Either<Failure, BillOfMaterialsEntity>> updatePrice(
    String billId,
    double price,
  );
  Future<Either<Failure, void>> deleteBillItem(String billId);
  Future<Either<Failure, BillOfMaterialsEntity>> getBillItemById(String billId);
}
