import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/material/data/repositories/material_repository_impl.dart';
import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:businesstrack/features/material/domain/repositories/material_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddMaterialParams extends Equatable {
  final String name;
  final String? description;
  final String? unit;
  final double? unitPrice;
  final double? minimumStock;
  final double? quantity;

  const AddMaterialParams({
    required this.name,
    this.description,
    this.unit,
    this.unitPrice,
    this.minimumStock,
    this.quantity,
  });

  @override
  List<Object?> get props => [
    name,
    description,
    unit,
    unitPrice,
    minimumStock,
    quantity,
  ];
}

final addMaterialUsecaseProvider = Provider<AddMaterialUsecase>((ref) {
  final materialRepository = ref.read(materialRepositoryProvider);
  return AddMaterialUsecase(materialRepository: materialRepository);
});

class AddMaterialUsecase implements UsecasewithParams<bool, AddMaterialParams> {
  final IMaterialRepository _materialRepository;

  AddMaterialUsecase({required IMaterialRepository materialRepository})
    : _materialRepository = materialRepository;

  @override
  Future<Either<Failure, bool>> call(AddMaterialParams params) {
    final entity = MaterialEntity(
      name: params.name,
      description: params.description,
      unit: params.unit ?? '',
      unitPrice: params.unitPrice ?? 0.0,
      // If UI does not provide stock, default to 0 to match web behaviour.
      quantity: params.quantity ?? 0.0,
      minimumStock: params.minimumStock ?? 0.0,
    );
    return _materialRepository.addMaterial(entity);
  }
}
