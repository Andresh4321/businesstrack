import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/bill_of_materials/data/repositories/bill_of_materials_repository_impl.dart';
import 'package:businesstrack/features/bill_of_materials/domain/entities/bill_of_materials_entity.dart';
import 'package:businesstrack/features/bill_of_materials/domain/repository/bill_of_materials_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetBillItemByIdParams extends Equatable {
  final String billId;

  const GetBillItemByIdParams({required this.billId});

  @override
  List<Object?> get props => [billId];
}

final getBillItemByIdUsecaseProvider = Provider<GetBillItemByIdUsecase>((ref) {
  final repository = ref.read(billOfMaterialsRepositoryProvider);
  return GetBillItemByIdUsecase(repository: repository);
});

class GetBillItemByIdUsecase
    implements UsecasewithParams<BillOfMaterialsEntity, GetBillItemByIdParams> {
  final IBillOfMaterialsRepository _repository;

  GetBillItemByIdUsecase({required IBillOfMaterialsRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, BillOfMaterialsEntity>> call(
    GetBillItemByIdParams params,
  ) {
    return _repository.getBillItemById(params.billId);
  }
}
