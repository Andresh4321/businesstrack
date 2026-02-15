import 'package:businesstrack/features/supplier/domain/entities/supplier_entity.dart';
import 'package:businesstrack/features/supplier/domain/usecases/addsupplier_usecase.dart';
import 'package:businesstrack/features/supplier/domain/usecases/deletesupplier_usecase.dart';
import 'package:businesstrack/features/supplier/domain/usecases/getAllsupplier_usecase.dart';
import 'package:businesstrack/features/supplier/domain/usecases/getsupplier_by_name.dart';
import 'package:businesstrack/features/supplier/domain/usecases/getsupplier_by_product.dart';
import 'package:businesstrack/features/supplier/domain/usecases/updatesupplier_usecase.dart';
import 'package:businesstrack/features/supplier/presentation/state/supplier.state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final supplierViewmodelProvider =
    NotifierProvider<SupplierViewmodel, SupplierState>(
      () => SupplierViewmodel(),
    );

class SupplierViewmodel extends Notifier<SupplierState> {
  late final AddSupplierUsecase _addSupplierUsecase;
  late final DeleteSupplierUsecase _deleteSupplierUsecase;
  late final GetAllSuppliersUsecase _getAllSuppliersUsecase;
  late final GetSupplierByNameUsecase _getSupplierByNameUsecase;
  late final GetSupplierByProductUsecase _getSupplierByProductUsecase;
  late final UpdateSupplierUsecase _updateSupplierUsecase;

  String _currentUserId = '';

  @override
  SupplierState build() {
    _addSupplierUsecase = ref.read(addSupplierUseCaseProvider);
    _deleteSupplierUsecase = ref.read(deleteSupplierUseCaseProvider);
    _getAllSuppliersUsecase = ref.read(getAllSuppliersUseCaseProvider);
    _getSupplierByNameUsecase = ref.read(getSupplierByNameUseCaseProvider);
    _getSupplierByProductUsecase = ref.read(
      getSupplierByProductUseCaseProvider,
    );
    _updateSupplierUsecase = ref.read(updateSupplierUseCaseProvider);
    return const SupplierState();
  }

  /// Set current user ID
  void setUserId(String userId) {
    _currentUserId = userId;
  }

  /// Get suppliers for current user
  Future<void> getSuppliers() async {
    if (_currentUserId.isEmpty) {
      state = state.copyWith(
        status: SupplierStatus.failure,
        errorMessage: 'User ID not set',
      );
      return;
    }

    state = state.copyWith(status: SupplierStatus.loading);

    final result = await _getAllSuppliersUsecase.call(
      GetAllSuppliersParams(userId: _currentUserId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: SupplierStatus.failure,
          errorMessage: failure.message,
        );
      },
      (suppliers) {
        state = state.copyWith(
          status: SupplierStatus.success,
          suppliers: suppliers,
        );
      },
    );
  }

  /// Add new supplier
  Future<void> addSupplier({
    required String name,
    required String email,
    required String contactName,
    required List<String> productNames,
  }) async {
    if (_currentUserId.isEmpty) {
      state = state.copyWith(
        status: SupplierStatus.failure,
        errorMessage: 'User ID not set',
      );
      return;
    }

    state = state.copyWith(status: SupplierStatus.loading);

    final result = await _addSupplierUsecase.call(
      AddSupplierParams(
        name: name,
        email: email,
        contactName: contactName,
        productNames: productNames,
        userId: _currentUserId,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: SupplierStatus.failure,
          errorMessage: failure.message,
        );
      },
      (_) {
        // Refresh suppliers list
        getSuppliers();
      },
    );
  }

  /// Delete supplier
  Future<void> deleteSupplier(String supplierId) async {
    if (_currentUserId.isEmpty) {
      state = state.copyWith(
        status: SupplierStatus.failure,
        errorMessage: 'User ID not set',
      );
      return;
    }

    state = state.copyWith(status: SupplierStatus.loading);

    final result = await _deleteSupplierUsecase.call(
      DeleteSupplierParams(supplierId: supplierId, userId: _currentUserId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: SupplierStatus.failure,
          errorMessage: failure.message,
        );
      },
      (_) {
        // Refresh suppliers list
        getSuppliers();
      },
    );
  }

  /// Update supplier
  Future<void> updateSupplier({
    required String id,
    required String name,
    required String email,
    required String contactName,
    required List<String> productNames,
  }) async {
    if (_currentUserId.isEmpty) {
      state = state.copyWith(
        status: SupplierStatus.failure,
        errorMessage: 'User ID not set',
      );
      return;
    }

    state = state.copyWith(status: SupplierStatus.loading);

    final result = await _updateSupplierUsecase.call(
      UpdateSupplierParams(
        id: id,
        name: name,
        email: email,
        contactName: contactName,
        productNames: productNames,
        userId: _currentUserId,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: SupplierStatus.failure,
          errorMessage: failure.message,
        );
      },
      (_) {
        // Refresh suppliers list
        getSuppliers();
      },
    );
  }

  /// Search suppliers by name
  Future<void> searchSuppliersByName(String name) async {
    if (_currentUserId.isEmpty) {
      state = state.copyWith(
        status: SupplierStatus.failure,
        errorMessage: 'User ID not set',
      );
      return;
    }

    state = state.copyWith(status: SupplierStatus.loading);

    final result = await _getSupplierByNameUsecase.call(
      GetSupplierByNameParams(name: name, userId: _currentUserId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: SupplierStatus.failure,
          errorMessage: failure.message,
        );
      },
      (suppliers) {
        state = state.copyWith(
          status: SupplierStatus.success,
          suppliers: suppliers,
        );
      },
    );
  }

  /// Search suppliers by product
  Future<void> searchSuppliersByProduct(String productName) async {
    if (_currentUserId.isEmpty) {
      state = state.copyWith(
        status: SupplierStatus.failure,
        errorMessage: 'User ID not set',
      );
      return;
    }

    state = state.copyWith(status: SupplierStatus.loading);

    final result = await _getSupplierByProductUsecase.call(
      GetSupplierByProductParams(
        productName: productName,
        userId: _currentUserId,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: SupplierStatus.failure,
          errorMessage: failure.message,
        );
      },
      (suppliers) {
        state = state.copyWith(
          status: SupplierStatus.success,
          suppliers: suppliers,
        );
      },
    );
  }

  /// Clear results and show all suppliers
  Future<void> clearSearch() async {
    await getSuppliers();
  }

  /// Reset state
  void resetState() {
    state = const SupplierState();
  }
}
