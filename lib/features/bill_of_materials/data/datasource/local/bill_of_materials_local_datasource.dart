import 'package:businesstrack/core/services/hive/Hive_Service.dart';
import 'package:businesstrack/features/bill_of_materials/data/datasource/bill_of_materials_datasource.dart';
import 'package:businesstrack/features/bill_of_materials/data/models/bill_of_materials_hive_model.dart';
import 'package:businesstrack/features/bill_of_materials/data/models/bill_of_materials_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final billOfMaterialsLocalProvider = Provider<IBillOfMaterialsLocalDataSource>((
  ref,
) {
  final hiveService = ref.read(hiveServiceProvider);
  return BillOfMaterialsLocalDatasource(hiveService: hiveService);
});

class BillOfMaterialsLocalDatasource
    implements IBillOfMaterialsLocalDataSource {
  final HiveService _hiveService;

  BillOfMaterialsLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<List<BillOfMaterialsModel>> getAllBillItems() async {
    try {
      final hiveModels = await _hiveService.getAllBillItems();
      return hiveModels
          .map(
            (hiveModel) =>
                BillOfMaterialsModel.fromEntity(hiveModel.toEntity()),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<BillOfMaterialsModel> createBillItem(
    BillOfMaterialsModel model,
  ) async {
    try {
      final hiveModel = BillOfMaterialsHiveModel.fromEntity(model.toEntity());
      await _hiveService.createBillItem(hiveModel);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BillOfMaterialsModel> updatePrice(String billId, double price) async {
    try {
      final hiveModel = await _hiveService.getBillItemById(billId);
      if (hiveModel == null) {
        throw Exception('Bill item not found');
      }
      final entity = hiveModel.toEntity();
      final currentModel = BillOfMaterialsModel.fromEntity(entity);
      final updatedModel = BillOfMaterialsModel(
        billId: currentModel.billId,
        materialId: currentModel.materialId,
        quantity: currentModel.quantity,
        price: price,
        userId: currentModel.userId,
        createdAt: currentModel.createdAt,
        updatedAt: DateTime.now(),
      );
      final updatedHiveModel = BillOfMaterialsHiveModel.fromEntity(
        updatedModel.toEntity(),
      );
      await _hiveService.updateBillItem(updatedHiveModel);
      return updatedModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteBillItem(String billId) async {
    try {
      await _hiveService.deleteBillItem(billId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BillOfMaterialsModel?> getBillItemById(String billId) async {
    try {
      final hiveModel = await _hiveService.getBillItemById(billId);
      if (hiveModel == null) return null;
      return BillOfMaterialsModel.fromEntity(hiveModel.toEntity());
    } catch (e) {
      return null;
    }
  }
}
