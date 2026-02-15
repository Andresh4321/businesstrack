import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';
import 'package:equatable/equatable.dart';

enum SupplierStatus { initial, loading, success, failure }

class SupplierState extends Equatable {
  final SupplierStatus status;
  final List<SupplierEntity> suppliers;
  final String? errorMessage;

  const SupplierState({
    this.status = SupplierStatus.initial,
    this.suppliers = const [],
    this.errorMessage,
  });

  SupplierState copyWith({
    SupplierStatus? status,
    List<SupplierEntity>? suppliers,
    String? errorMessage,
  }) {
    return SupplierState(
      status: status ?? this.status,
      suppliers: suppliers ?? this.suppliers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, suppliers, errorMessage];
}
