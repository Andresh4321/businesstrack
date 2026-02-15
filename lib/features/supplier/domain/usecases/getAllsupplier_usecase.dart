import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/supplier/data/repositories/supplier_respository.dart';
import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';
import 'package:businesstrack/features/supplier/domain/repository/supplier_respository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetAllSuppliersParams extends Equatable {
  final String userId;

  const GetAllSuppliersParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GetAllSuppliersUsecase
    implements UsecasewithParams<List<SupplierEntity>, GetAllSuppliersParams> {
  final ISupplierRepository _supplierRepository;

  GetAllSuppliersUsecase({required ISupplierRepository supplierRepository})
    : _supplierRepository = supplierRepository;

  @override
  Future<Either<Failure, List<SupplierEntity>>> call(
    GetAllSuppliersParams params,
  ) {
    return _supplierRepository.getSuppliers(params.userId);
  }
}

final getAllSuppliersUseCaseProvider = Provider<GetAllSuppliersUsecase>((ref) {
  final supplierRepository = ref.read(supplierRepositoryProvider);
  return GetAllSuppliersUsecase(supplierRepository: supplierRepository);
});
