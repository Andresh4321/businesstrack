import 'package:businesstrack/features/stock/domain/entities/stock_entity.dart';
import 'package:equatable/equatable.dart';

enum StockStatus { initial, loading, loaded, error }

class StockState extends Equatable {
  final StockStatus status;
  final List<StockEntity> stock;
  final StockEntity? selectedStock;
  final String? errorMessage;

  const StockState({
    this.status = StockStatus.initial,
    this.stock = const [],
    this.selectedStock,
    this.errorMessage,
  });

  StockState copyWith({
    StockStatus? status,
    List<StockEntity>? stock,
    StockEntity? selectedStock,
    String? errorMessage,
  }) {
    return StockState(
      status: status ?? this.status,
      stock: stock ?? this.stock,
      selectedStock: selectedStock ?? this.selectedStock,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, stock, selectedStock, errorMessage];
}
