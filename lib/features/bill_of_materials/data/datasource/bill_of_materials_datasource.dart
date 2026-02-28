import 'package:businesstrack/features/bill_of_materials/data/models/bill_of_materials_model.dart';

abstract interface class IBillOfMaterialsDataSource {
  Future<List<BillOfMaterialsModel>> getAllBillItems();
  Future<BillOfMaterialsModel> createBillItem(BillOfMaterialsModel model);
  Future<BillOfMaterialsModel> updatePrice(String billId, double price);
  Future<void> deleteBillItem(String billId);
  Future<BillOfMaterialsModel?> getBillItemById(String billId);
}

abstract interface class IBillOfMaterialsRemoteDataSource
    extends IBillOfMaterialsDataSource {}

abstract interface class IBillOfMaterialsLocalDataSource
    extends IBillOfMaterialsDataSource {}
