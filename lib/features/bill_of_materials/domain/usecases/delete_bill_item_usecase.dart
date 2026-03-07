import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/bill_of_materials/data/repositories/bill_of_materials_repository_impl.dart';
import 'package:businesstrack/features/bill_of_materials/domain/repository/bill_of_materials_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteBillItemParams extends Equatable {
  final String billId;

  const DeleteBillItemParams({required this.billId});

  @override
  List<Object?> get props => [billId];
}

final deleteBillItemUsecaseProvider = Provider<DeleteBillItemUsecase>((ref) {
  final repository = ref.read(billOfMaterialsRepositoryProvider);
  return DeleteBillItemUsecase(repository: repository);
});

class DeleteBillItemUsecase
    implements UsecasewithParams<void, DeleteBillItemParams> {
  final IBillOfMaterialsRepository _repository;

  DeleteBillItemUsecase({required IBillOfMaterialsRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(DeleteBillItemParams params) {
    return _repository.deleteBillItem(params.billId);
  }
}
