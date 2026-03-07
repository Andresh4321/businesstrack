import 'package:businesstrack/features/dashboard/presentation/viewmodel/dashboard_viewmodel.dart';
import 'package:businesstrack/features/material/domain/entities/material_entity.dart';
import 'package:businesstrack/features/material/domain/usecases/add_material_usecase.dart';
import 'package:businesstrack/features/material/domain/usecases/delete_material_usecase.dart';
import 'package:businesstrack/features/material/domain/usecases/get_all_materials_usecase.dart';
import 'package:businesstrack/features/material/domain/usecases/search_materials_usecase.dart';
import 'package:businesstrack/features/material/domain/usecases/update_material_usecase.dart';
import 'package:businesstrack/features/material/presentation/state/material_state.dart';
import 'package:businesstrack/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final materialViewModelProvider =
    NotifierProvider<MaterialViewModel, MaterialState>(
      () => MaterialViewModel(),
    );

class MaterialViewModel extends Notifier<MaterialState> {
  late final AddMaterialUsecase _addMaterialUsecase;
  late final GetAllMaterialsUsecase _getAllMaterialsUsecase;
  late final UpdateMaterialUsecase _updateMaterialUsecase;
  late final DeleteMaterialUsecase _deleteMaterialUsecase;
  late final SearchMaterialsUsecase _searchMaterialsUsecase;

  @override
  MaterialState build() {
    _addMaterialUsecase = ref.read(addMaterialUsecaseProvider);
    _getAllMaterialsUsecase = ref.read(getAllMaterialsUsecaseProvider);
    _updateMaterialUsecase = ref.read(updateMaterialUsecaseProvider);
    _deleteMaterialUsecase = ref.read(deleteMaterialUsecaseProvider);
    _searchMaterialsUsecase = ref.read(searchMaterialsUsecaseProvider);
    return const MaterialState();
  }

  // Add Material
  Future<void> addMaterial({
    required String name,
    String? description,
    String? unit,
    double? unitPrice,
    double? minimumStock,
    double? quantity,
  }) async {
    state = state.copyWith(status: MaterialStatus.loading);

    final params = AddMaterialParams(
      name: name,
      description: description,
      unit: unit,
      unitPrice: unitPrice,
      minimumStock: minimumStock ?? 0,
      quantity: quantity,
    );

    final result = await _addMaterialUsecase(params);

    await result.fold(
      (failure) async {
        state = state.copyWith(
          status: MaterialStatus.error,
          errorMessage: failure.message,
        );
      },
      (isAdded) async {
        state = state.copyWith(status: MaterialStatus.loaded);
        await getAllMaterials(); // Refresh list after adding
        ref.read(dashboardViewModelProvider.notifier).refreshDashboard();
      },
    );
  }

  // Get All Materials
  Future<void> getAllMaterials() async {
    state = state.copyWith(status: MaterialStatus.loading);
    try {
      final stockRepository = ref.read(stockRepositoryProvider);
      final materialResult = await _getAllMaterialsUsecase();

      final materials = materialResult.fold<List<MaterialEntity>>((failure) {
        state = state.copyWith(
          status: MaterialStatus.error,
          errorMessage: failure.message,
        );
        return [];
      }, (materials) => materials);

      if (state.status == MaterialStatus.error) {
        return;
      }

      List<MaterialEntity> materialsWithActualStock = materials;

      try {
        final stockResult = await stockRepository.getAllStockTransactions();

        materialsWithActualStock = stockResult.fold((_) => materials, (
          transactions,
        ) {
          final quantityByMaterialId = <String, double>{};

          for (final transaction in transactions) {
            final currentQty =
                quantityByMaterialId[transaction.materialId] ?? 0.0;
            final transactionType = transaction.transactionType.toLowerCase();

            if (transactionType == 'in' ||
                transactionType == 'add' ||
                transactionType == 'increase') {
              quantityByMaterialId[transaction.materialId] =
                  currentQty + transaction.quantity;
            } else {
              quantityByMaterialId[transaction.materialId] =
                  currentQty - transaction.quantity;
            }
          }

          return materials.map((material) {
            final materialId = material.materialId;
            if (materialId == null) {
              return material;
            }

            final calculatedQty = quantityByMaterialId[materialId];
            if (calculatedQty == null) {
              return material;
            }

            return material.copyWith(
              quantity: calculatedQty < 0 ? 0 : calculatedQty,
            );
          }).toList();
        });
      } catch (_) {
        materialsWithActualStock = materials;
      }

      state = state.copyWith(
        status: MaterialStatus.loaded,
        materials: materialsWithActualStock,
      );
    } catch (e) {
      state = state.copyWith(
        status: MaterialStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // Update Material
  Future<bool> updateMaterial({
    required String materialId,
    required String name,
    String? description,
    String? unit,
    double? unitPrice,
    double? minimumStock,
    int? quantity,
  }) async {
    state = state.copyWith(status: MaterialStatus.loading);

    final index = state.materials.indexWhere((m) => m.materialId == materialId);
    if (index == -1) {
      state = state.copyWith(
        status: MaterialStatus.error,
        errorMessage: 'Material not found',
      );
      return false;
    }

    final materialEntity = state.materials[index].copyWith(
      materialId: materialId,
      name: name,
      description: description,
      unit: unit,
      unitPrice: unitPrice,
      quantity: quantity?.toDouble() ?? state.materials[index].quantity,
      minimumStock: minimumStock ?? state.materials[index].minimumStock,
    );

    final result = await _updateMaterialUsecase(
      UpdateMaterialParams(material: materialEntity),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: MaterialStatus.error,
          errorMessage: failure.message,
        );
      },
      (isUpdated) {
        if (isUpdated) {
          getAllMaterials(); // Refresh list after update
          ref.read(dashboardViewModelProvider.notifier).refreshDashboard();
        }
      },
    );

    return result.fold((_) => false, (isUpdated) => isUpdated);
  }

  // Delete Material
  Future<void> deleteMaterial(String materialId) async {
    state = state.copyWith(status: MaterialStatus.loading);

    final result = await _deleteMaterialUsecase(
      DeleteMaterialParams(materialId: materialId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: MaterialStatus.error,
          errorMessage: failure.message,
        );
      },
      (isDeleted) {
        if (isDeleted) {
          getAllMaterials(); // Refresh list after delete
          ref.read(dashboardViewModelProvider.notifier).refreshDashboard();
        }
      },
    );
  }

  // Search Materials
  Future<void> searchMaterials(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(
        status: MaterialStatus.loaded,
        materials: state.materials,
      );
      return;
    }

    final result = await _searchMaterialsUsecase(
      SearchMaterialsParams(query: query),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: MaterialStatus.error,
          errorMessage: failure.message,
        );
      },
      (materials) {
        state = state.copyWith(
          status: MaterialStatus.loaded,
          materials: materials,
        );
      },
    );
  }
}
