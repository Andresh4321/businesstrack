import 'package:businesstrack/features/material/presentation/viewmodel/material_viewmodel.dart';
import 'package:businesstrack/features/stock/domain/usecases/create_stock_transaction_usecase.dart';
import 'package:businesstrack/features/stock/domain/usecases/delete_stock_transaction_usecase.dart';
import 'package:businesstrack/features/stock/domain/usecases/get_all_stock_transactions_usecase.dart';
import 'package:businesstrack/features/stock/domain/usecases/update_stock_usecase.dart';
import 'package:businesstrack/features/stock/presentation/state/stock_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stockViewModelProvider = NotifierProvider<StockViewModel, StockState>(
  () => StockViewModel(),
);

class StockViewModel extends Notifier<StockState> {
  late final UpdateStockUsecase _updateStockUsecase;
  late final GetAllStockTransactionsUsecase _getAllStockTransactionsUsecase;
  late final CreateStockTransactionUsecase _createStockTransactionUsecase;
  late final DeleteStockTransactionUsecase _deleteStockTransactionUsecase;

  @override
  StockState build() {
    _updateStockUsecase = ref.read(updateStockUsecaseProvider);
    _getAllStockTransactionsUsecase = ref.read(
      getAllStockTransactionsUsecaseProvider,
    );
    _createStockTransactionUsecase = ref.read(
      createStockTransactionUsecaseProvider,
    );
    _deleteStockTransactionUsecase = ref.read(
      deleteStockTransactionUsecaseProvider,
    );
    return const StockState();
  }

  // Get All Stock Transactions
  Future<void> getAllStockTransactions({int page = 1, int limit = 10}) async {
    state = state.copyWith(status: StockStatus.loading);
    try {
      final result = await _getAllStockTransactionsUsecase();
      result.fold(
        (failure) {
          state = state.copyWith(
            status: StockStatus.error,
            errorMessage: failure.message,
          );
        },
        (stockList) {
          state = state.copyWith(status: StockStatus.loaded, stock: stockList);
        },
      );
    } catch (e) {
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
      final result = await _createStockTransactionUsecase(
        CreateStockTransactionParams(
          materialId: materialId,
          quantity: quantity,
          transactionType: transactionType,
          description: description,
        ),
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
      (_) {
        state = state.copyWith(status: StockStatus.loaded);
        getAllStockTransactions();
      },
    );
  }

  // Delete Stock Transaction (history row)
  Future<void> deleteStock(String transactionId) async {
    state = state.copyWith(status: StockStatus.loading);
    try {
      final result = await _deleteStockTransactionUsecase(
        DeleteStockTransactionParams(transactionId: transactionId),
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
