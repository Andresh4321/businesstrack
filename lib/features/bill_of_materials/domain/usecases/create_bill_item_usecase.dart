import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/bill_of_materials/data/repositories/bill_of_materials_repository_impl.dart';
import 'package:businesstrack/features/bill_of_materials/domain/entities/bill_of_materials_entity.dart';
import 'package:businesstrack/features/bill_of_materials/domain/repository/bill_of_materials_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateBillItemParams extends Equatable {
  final BillOfMaterialsEntity entity;

  const CreateBillItemParams({required this.entity});

  @override
  List<Object?> get props => [entity];
}

final createBillItemUsecaseProvider = Provider<CreateBillItemUsecase>((ref) {
  final repository = ref.read(billOfMaterialsRepositoryProvider);
  return CreateBillItemUsecase(repository: repository);
});

class CreateBillItemUsecase
    implements UsecasewithParams<BillOfMaterialsEntity, CreateBillItemParams> {
  final IBillOfMaterialsRepository _repository;

  CreateBillItemUsecase({required IBillOfMaterialsRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, BillOfMaterialsEntity>> call(
    CreateBillItemParams params,
  ) {
    return _repository.createBillItem(params.entity);
  }
}
