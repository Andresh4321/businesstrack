import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/bill_of_materials/data/repositories/bill_of_materials_repository_impl.dart';
import 'package:businesstrack/features/bill_of_materials/domain/entities/bill_of_materials_entity.dart';
import 'package:businesstrack/features/bill_of_materials/domain/repository/bill_of_materials_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllBillItemsUsecaseProvider = Provider<GetAllBillItemsUsecase>((ref) {
  final repository = ref.read(billOfMaterialsRepositoryProvider);
  return GetAllBillItemsUsecase(repository: repository);
});

class GetAllBillItemsUsecase
    implements UsecasewithoutParams<List<BillOfMaterialsEntity>> {
  final IBillOfMaterialsRepository _repository;

  GetAllBillItemsUsecase({required IBillOfMaterialsRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<BillOfMaterialsEntity>>> call() {
    return _repository.getAllBillItems();
  }
}
