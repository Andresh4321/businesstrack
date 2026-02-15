import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/supplier/data/repositories/supplier_respository.dart';
import 'package:businesstrack/features/supplier/domain/repository/supplier_respository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteSupplierParams extends Equatable {
  final String supplierId;
  final String userId;

  const DeleteSupplierParams({required this.supplierId, required this.userId});

  @override
  List<Object?> get props => [supplierId, userId];
}

class DeleteSupplierUsecase
    implements UsecasewithParams<void, DeleteSupplierParams> {
  final ISupplierRepository _supplierRepository;

  DeleteSupplierUsecase({required ISupplierRepository supplierRepository})
    : _supplierRepository = supplierRepository;

  @override
  Future<Either<Failure, void>> call(DeleteSupplierParams params) {
    return _supplierRepository.deleteSupplier(params.supplierId, params.userId);
  }
}

final deleteSupplierUseCaseProvider = Provider<DeleteSupplierUsecase>((ref) {
  final supplierRepository = ref.read(supplierRepositoryProvider);
  return DeleteSupplierUsecase(supplierRepository: supplierRepository);
});
