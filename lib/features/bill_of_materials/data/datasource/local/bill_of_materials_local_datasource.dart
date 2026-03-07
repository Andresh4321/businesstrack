import 'package:businesstrack/core/services/hive_service.dart';
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
      // Get from local Hive storage
      // Assuming HiveService has a method for this
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<BillOfMaterialsModel> createBillItem(
    BillOfMaterialsModel model,
  ) async {
    try {
      // Save to local Hive storage
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BillOfMaterialsModel> updatePrice(String billId, double price) async {
    try {
      // Update in local Hive storage
      throw UnimplementedError('Use remote for updates');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteBillItem(String billId) async {
    try {
      // Delete from local Hive storage
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BillOfMaterialsModel?> getBillItemById(String billId) async {
    try {
      // Get from local Hive storage
      return null;
    } catch (e) {
      return null;
    }
  }
}
