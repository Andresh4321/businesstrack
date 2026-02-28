import 'package:businesstrack/features/material/data/repositories/material_repository_impl.dart';
import 'package:businesstrack/features/material/presentation/viewmodel/material_viewmodel.dart';
import 'package:businesstrack/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:businesstrack/features/stock/domain/usecases/update_stock_usecase.dart';
import 'package:businesstrack/features/stock/presentation/state/stock_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stockViewModelProvider = NotifierProvider<StockViewModel, StockState>(
  () => StockViewModel(),
);

class StockViewModel extends Notifier<StockState> {
  late final UpdateStockUsecase _updateStockUsecase;

  @override
  StockState build() {
    _updateStockUsecase = ref.read(updateStockUsecaseProvider);
    return const StockState();
  }

  // Get All Stock Transactions with pagination
  Future<void> getAllStockTransactions({int page = 1, int limit = 10}) async {
    print('📊 [StockViewModel] Loading stock transactions...');
    state = state.copyWith(status: StockStatus.loading);
    try {
      final repository = ref.read(stockRepositoryProvider);
      final result = await repository.getAllStockTransactions();

      result.fold(
        (failure) {
          print('❌ [StockViewModel] Failed: ${failure.message}');
          state = state.copyWith(
            status: StockStatus.error,
            errorMessage: failure.message,
          );
        },
        (stockList) {
          print('✅ [StockViewModel] Loaded ${stockList.length} transactions');
          if (stockList.isNotEmpty) {
            print(
              '✅ [StockViewModel] First transaction: ${stockList.first.stockId}, ${stockList.first.materialId}',
            );
          }
          state = state.copyWith(status: StockStatus.loaded, stock: stockList);
        },
      );
    } catch (e) {
      print('❌ [StockViewModel] Exception: $e');
      state = state.copyWith(
        status: StockStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // Create Stock Transaction (Add/Remove Stock)
  Future<void> createStockTransaction({
    required String materialId,
    required double quantity,
    required String transactionType, // 'in' for add, 'out' for remove
    String? description,
  }) async {
    state = state.copyWith(status: StockStatus.loading);

    try {
      final repository = ref.read(stockRepositoryProvider);

      // Create stock transaction through repository
      // This will be handled by backend - we just need to send the data
      final result = await repository.createStockTransaction(
        materialId: materialId,
        quantity: quantity,
        transactionType: transactionType,
        description: description,
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            status: StockStatus.error,
            errorMessage: failure.message,
          );
        },
        (_) {
          state = state.copyWith(status: StockStatus.loaded);
          // Refresh both materials and stock transactions
          ref.read(materialViewModelProvider.notifier).getAllMaterials();
          getAllStockTransactions();
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: StockStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // Update Stock
  Future<void> updateStock({
    required String stockId,
    String? materialId,
    int? quantity,
    String? location,
  }) async {
    state = state.copyWith(status: StockStatus.loading);

    final params = UpdateStockParams(
      stockId: stockId,
      materialId: materialId,
      quantity: quantity,
      description: location,
    );

    final result = await _updateStockUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: StockStatus.error,
          errorMessage: failure.message,
        );
      },
      (isUpdated) {
        state = state.copyWith(status: StockStatus.loaded);
        getAllStockTransactions();
      },
    );
  }

  // Delete Stock
  Future<void> deleteStock(String stockId) async {
    state = state.copyWith(status: StockStatus.loading);
    try {
      final repository = ref.read(stockRepositoryProvider);
      final result = await repository.deleteStockTransaction(stockId);

      result.fold(
        (failure) {
          state = state.copyWith(
            status: StockStatus.error,
            errorMessage: failure.message,
          );
        },
        (_) {
          state = state.copyWith(status: StockStatus.loaded);
          getAllStockTransactions();
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: StockStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
