import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/bill_of_materials/data/repositories/bill_of_materials_repository_impl.dart';
import 'package:businesstrack/features/bill_of_materials/domain/entities/bill_of_materials_entity.dart';
import 'package:businesstrack/features/bill_of_materials/domain/repository/bill_of_materials_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateBillPriceParams extends Equatable {
  final String billId;
  final double price;

  const UpdateBillPriceParams({required this.billId, required this.price});

  @override
  List<Object?> get props => [billId, price];
}

final updateBillPriceUsecaseProvider = Provider<UpdateBillPriceUsecase>((ref) {
  final repository = ref.read(billOfMaterialsRepositoryProvider);
  return UpdateBillPriceUsecase(repository: repository);
});

class UpdateBillPriceUsecase
    implements UsecasewithParams<BillOfMaterialsEntity, UpdateBillPriceParams> {
  final IBillOfMaterialsRepository _repository;

  UpdateBillPriceUsecase({required IBillOfMaterialsRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, BillOfMaterialsEntity>> call(
    UpdateBillPriceParams params,
  ) {
    return _repository.updatePrice(params.billId, params.price);
  }
}
