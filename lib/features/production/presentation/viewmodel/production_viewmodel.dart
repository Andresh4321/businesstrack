import 'package:businesstrack/features/production/data/repositories/production_repository_impl.dart';
import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:businesstrack/features/production/domain/usecases/delete_production_usecase.dart';
import 'package:businesstrack/features/production/domain/usecases/end_production_usecase.dart';
import 'package:businesstrack/features/production/domain/usecases/get_all_production_usecase.dart';
import 'package:businesstrack/features/production/domain/usecases/start_production_usecase.dart';
import 'package:businesstrack/features/production/domain/usecases/update_production_usecase.dart';
import 'package:businesstrack/features/production/presentation/state/production_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productionViewModelProvider =
    NotifierProvider<ProductionViewModel, ProductionState>(
      () => ProductionViewModel(),
    );

class ProductionViewModel extends Notifier<ProductionState> {
  late final StartProductionUsecase _startProductionUsecase;
  late final GetAllProductionUsecase _getAllProductionUsecase;
  late final EndProductionUsecase _endProductionUsecase;
  late final UpdateProductionUsecase _updateProductionUsecase;
  late final DeleteProductionUsecase _deleteProductionUsecase;

  @override
  ProductionState build() {
    _startProductionUsecase = ref.read(startProductionUsecaseProvider);
    _getAllProductionUsecase = ref.read(getAllProductionUsecaseProvider);
    _endProductionUsecase = ref.read(endProductionUsecaseProvider);
    _updateProductionUsecase = ref.read(updateProductionUsecaseProvider);
    _deleteProductionUsecase = ref.read(deleteProductionUsecaseProvider);
    return const ProductionState();
  }

  // Start Production
  Future<bool> startProduction({
    required String recipeId,
    required int quantity,
    double? estimatedOutput,
  }) async {
    state = state.copyWith(status: ProductionStatus.loading);

    final result = await _startProductionUsecase(
      StartProductionParams(
        recipeId: recipeId,
        quantity: quantity,
        estimatedOutput: estimatedOutput,
      ),
    );

    bool started = false;

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductionStatus.error,
          errorMessage: failure.message,
        );
      },
      (isStarted) {
        if (isStarted) {
          started = true;
          state = state.copyWith(status: ProductionStatus.loaded);
          getAllProduction(); // Refresh list
        } else {
          state = state.copyWith(
            status: ProductionStatus.error,
            errorMessage: 'Material out of stock',
          );
        }
      },
    );

    return started;
  }

  // Get All Production
  Future<void> getAllProduction() async {
    state = state.copyWith(status: ProductionStatus.loading);
    final result = await _getAllProductionUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductionStatus.error,
          errorMessage: failure.message,
        );
      },
      (production) {
        state = state.copyWith(
          status: ProductionStatus.loaded,
          production: production,
        );
      },
    );
  }

  // End Production
  Future<bool> endProduction(
    String productionId, {
    double? actualOutput,
  }) async {
    state = state.copyWith(status: ProductionStatus.loading);

    final result = await _endProductionUsecase(
      EndProductionParams(
        productionId: productionId,
        actualOutput: actualOutput,
      ),
    );

    bool ended = false;

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductionStatus.error,
          errorMessage: failure.message,
        );
      },
      (isEnded) {
        ended = isEnded;
        if (isEnded) {
          state = state.copyWith(status: ProductionStatus.loaded);
          getAllProduction(); // Refresh list
        } else {
          state = state.copyWith(
            status: ProductionStatus.error,
            errorMessage: 'Failed to complete batch',
          );
        }
      },
    );

    return ended;
  }

  // Update Production
  Future<void> updateProduction(ProductionEntity production) async {
    state = state.copyWith(status: ProductionStatus.loading);
    final result = await _updateProductionUsecase(
      UpdateProductionParams(production: production),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductionStatus.error,
          errorMessage: failure.message,
        );
      },
      (isUpdated) {
        state = state.copyWith(status: ProductionStatus.loaded);
        getAllProduction(); // Refresh list
      },
    );
  }

  Future<bool> deleteProduction(String productionId) async {
    state = state.copyWith(status: ProductionStatus.loading);

    final result = await _deleteProductionUsecase(
      DeleteProductionParams(productionId: productionId),
    );

    bool deleted = false;

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductionStatus.error,
          errorMessage: failure.message,
        );
      },
      (isDeleted) {
        deleted = isDeleted;
        if (isDeleted) {
          state = state.copyWith(status: ProductionStatus.loaded);
          getAllProduction();
        } else {
          state = state.copyWith(
            status: ProductionStatus.error,
            errorMessage: 'Failed to delete batch',
          );
        }
      },
    );

    return deleted;
  }
}
