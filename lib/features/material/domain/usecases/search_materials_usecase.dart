import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/material/data/repositories/material_repository_impl.dart';
import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:businesstrack/features/material/domain/repositories/material_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchMaterialsParams extends Equatable {
  final String query;

  const SearchMaterialsParams({required this.query});

  @override
  List<Object?> get props => [query];
}

final searchMaterialsUsecaseProvider = Provider<SearchMaterialsUsecase>((ref) {
  final materialRepository = ref.read(materialRepositoryProvider);
  return SearchMaterialsUsecase(materialRepository: materialRepository);
});

class SearchMaterialsUsecase
    implements UsecasewithParams<List<MaterialEntity>, SearchMaterialsParams> {
  final IMaterialRepository _materialRepository;

  SearchMaterialsUsecase({required IMaterialRepository materialRepository})
    : _materialRepository = materialRepository;

  @override
  Future<Either<Failure, List<MaterialEntity>>> call(
    SearchMaterialsParams params,
  ) {
    return _materialRepository.searchMaterials(params.query);
  }
}
