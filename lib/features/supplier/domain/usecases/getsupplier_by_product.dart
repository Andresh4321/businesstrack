import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/supplier/data/repositories/supplier_respository.dart';
import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';
import 'package:businesstrack/features/supplier/domain/repository/supplier_respository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetSupplierByProductParams extends Equatable {
  final String productName;
  final String userId;

  const GetSupplierByProductParams({
    required this.productName,
    required this.userId,
  });

  @override
  List<Object?> get props => [productName, userId];
}

class GetSupplierByProductUsecase
    implements
        UsecasewithParams<List<SupplierEntity>, GetSupplierByProductParams> {
  final ISupplierRepository _supplierRepository;

  GetSupplierByProductUsecase({required ISupplierRepository supplierRepository})
    : _supplierRepository = supplierRepository;

  @override
  Future<Either<Failure, List<SupplierEntity>>> call(
    GetSupplierByProductParams params,
  ) {
    return _supplierRepository.searchSuppliersByProduct(
      params.productName,
      params.userId,
    );
  }
}

final getSupplierByProductUseCaseProvider =
    Provider<GetSupplierByProductUsecase>((ref) {
      final supplierRepository = ref.read(supplierRepositoryProvider);
      return GetSupplierByProductUsecase(
        supplierRepository: supplierRepository,
      );
    });
