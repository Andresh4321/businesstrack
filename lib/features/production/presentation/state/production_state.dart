import 'package:businesstrack/features/production/domain/entities/production_entity.dart';
import 'package:equatable/equatable.dart';

enum ProductionStatus { initial, loading, loaded, error }

class ProductionState extends Equatable {
  final ProductionStatus status;
  final List<ProductionEntity> production;
  final ProductionEntity? selectedProduction;
  final String? errorMessage;

  const ProductionState({
    this.status = ProductionStatus.initial,
    this.production = const [],
    this.selectedProduction,
    this.errorMessage,
  });

  ProductionState copyWith({
    ProductionStatus? status,
    List<ProductionEntity>? production,
    ProductionEntity? selectedProduction,
    String? errorMessage,
  }) {
    return ProductionState(
      status: status ?? this.status,
      production: production ?? this.production,
      selectedProduction: selectedProduction ?? this.selectedProduction,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    production,
    selectedProduction,
    errorMessage,
  ];
}
