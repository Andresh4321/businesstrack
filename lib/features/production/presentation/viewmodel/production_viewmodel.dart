import 'package:businesstrack/features/production/data/repositories/production_repository_impl.dart';
import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:businesstrack/features/production/domain/usecases/start_production_usecase.dart';
import 'package:businesstrack/features/production/presentation/state/production_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productionViewModelProvider =
    NotifierProvider<ProductionViewModel, ProductionState>(
      () => ProductionViewModel(),
    );

class ProductionViewModel extends Notifier<ProductionState> {
  late final StartProductionUsecase _startProductionUsecase;

  @override
  ProductionState build() {
    _startProductionUsecase = ref.read(startProductionUsecaseProvider);
    return const ProductionState();
  }

  // Start Production
  Future<bool> startProduction({
    required String recipeId,
    required int quantity,
    double? estimatedOutput,
  }) async {
    state = state.copyWith(status: ProductionStatus.loading);

    final production = ProductionEntity(
      recipeId: recipeId,
      batchQuantity: quantity.toDouble(),
      estimatedOutput: estimatedOutput ?? quantity.toDouble(),
      itemsUsed: [],
      status: 'ongoing',
    );

    final repository = ref.read(productionRepositoryProvider);
    final result = await repository.startProduction(production);

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

    final repository = ref.read(productionRepositoryProvider);
    final result = await repository.getAllProduction();

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

    final repository = ref.read(productionRepositoryProvider);
    final result = await repository.endProduction(
      productionId,
      actualOutput: actualOutput,
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

    final repository = ref.read(productionRepositoryProvider);
    final result = await repository.updateProduction(production);

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
}
