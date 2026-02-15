import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/supplier/data/repositories/supplier_respository.dart';
import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';
import 'package:businesstrack/features/supplier/domain/repository/supplier_respository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateSupplierParams extends Equatable {
  final String id;
  final String name;
  final String email;
  final String contactName;
  final List<String> productNames;
  final String userId;

  const UpdateSupplierParams({
    required this.id,
    required this.name,
    required this.email,
    required this.contactName,
    required this.productNames,
    required this.userId,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    contactName,
    productNames,
    userId,
  ];
}

class UpdateSupplierUsecase
    implements UsecasewithParams<void, UpdateSupplierParams> {
  final ISupplierRepository _supplierRepository;

  UpdateSupplierUsecase({required ISupplierRepository supplierRepository})
    : _supplierRepository = supplierRepository;

  @override
  Future<Either<Failure, void>> call(UpdateSupplierParams params) {
    final entity = SupplierEntity(
      id: params.id,
      name: params.name,
      email: params.email,
      contactName: params.contactName,
      productNames: params.productNames,
      userId: params.userId,
    );
    return _supplierRepository.updateSupplier(entity, params.userId);
  }
}

final updateSupplierUseCaseProvider = Provider<UpdateSupplierUsecase>((ref) {
  final supplierRepository = ref.read(supplierRepositoryProvider);
  return UpdateSupplierUsecase(supplierRepository: supplierRepository);
});
