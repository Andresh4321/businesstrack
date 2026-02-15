import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/supplier/data/repositories/supplier_respository.dart';
import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';
import 'package:businesstrack/features/supplier/domain/repository/supplier_respository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetSupplierByNameParams extends Equatable {
  final String name;
  final String userId;

  const GetSupplierByNameParams({required this.name, required this.userId});

  @override
  List<Object?> get props => [name, userId];
}

class GetSupplierByNameUsecase
    implements
        UsecasewithParams<List<SupplierEntity>, GetSupplierByNameParams> {
  final ISupplierRepository _supplierRepository;

  GetSupplierByNameUsecase({required ISupplierRepository supplierRepository})
    : _supplierRepository = supplierRepository;

  @override
  Future<Either<Failure, List<SupplierEntity>>> call(
    GetSupplierByNameParams params,
  ) {
    return _supplierRepository.searchSuppliersByName(
      params.name,
      params.userId,
    );
  }
}

final getSupplierByNameUseCaseProvider = Provider<GetSupplierByNameUsecase>((
  ref,
) {
  final supplierRepository = ref.read(supplierRepositoryProvider);
  return GetSupplierByNameUsecase(supplierRepository: supplierRepository);
});
