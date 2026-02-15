import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/supplier/data/repositories/supplier_respository.dart';
import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';
import 'package:businesstrack/features/supplier/domain/repository/supplier_respository.dart';
import 'package:dartz/dartz.dart';
import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';
import 'package:businesstrack/features/supplier/domain/repository/supplier_respository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddSupplierParams extends Equatable {
  final String name;
  final String email;
  final String contactName;
  final List<String> productNames;
  final String userId;

  const AddSupplierParams({
    required this.name,
    required this.email,
    required this.contactName,
    required this.productNames,
    required this.userId,
  });

  @override
  List<Object?> get props => [name, email, contactName, productNames, userId];
}

class AddSupplierUsecase implements UsecasewithParams<void, AddSupplierParams> {
  final ISupplierRepository _supplierRepository;

  AddSupplierUsecase({required ISupplierRepository supplierRepository})
    : _supplierRepository = supplierRepository;

  @override
  Future<Either<Failure, void>> call(AddSupplierParams params) {
    final entity = SupplierEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: params.name,
      email: params.email,
      contactName: params.contactName,
      productNames: params.productNames,
      userId: params.userId,
    );
    return _supplierRepository.addSupplier(entity, params.userId);
  }
}

final addSupplierUseCaseProvider = Provider<AddSupplierUsecase>((ref) {
  final supplierRepository = ref.read(supplierRepositoryProvider);
  return AddSupplierUsecase(supplierRepository: supplierRepository);
});
