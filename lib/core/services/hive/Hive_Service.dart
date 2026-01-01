// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive/hive.dart';
// import 'package:lost_n_found/core/constants/hive_table_constant.dart';
// import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
// import 'package:path_provider/path_provider.dart';

// final hiveServiceProvider = Provider<HiveService>((ref) {
//   return HiveService();
// });

// class HiveService {
//   //Get batch box
//   Box<BatchHiveModel> get _batchBox =>
//       Hive.box<BatchHiveModel>(HiveTableConstant.batchTable);

//   //Initialize Hive
//   Future<void> init() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final path = '${directory.path}/${HiveTableConstant.dbName}';
//     Hive.init(path);
//     _registerAdapters();
//     await _openBoxes();
//     await insertDummyBatches();
//   }

//   Future<void> insertDummyBatches() async {
//     final box = await Hive.openBox<BatchHiveModel>(
//       HiveTableConstant.batchTable,
//     );
//     final dummyBatches = [
//       BatchHiveModel(batchName: '35-A'),
//       BatchHiveModel(batchName: '35-B'),
//       BatchHiveModel(batchName: '35-C'),
//       BatchHiveModel(batchName: '35-D'),
//     ];
//     for (var batch in dummyBatches) {
//       await box.put(batch.batchId, batch);
//     }
//     await box.close();
//   }

//   //Register all type adapters
//   void _registerAdapters() {
//     if (!Hive.isAdapterRegistered(HiveTableConstant.batchTypeId)) {
//       Hive.registerAdapter(BatchHiveModelAdapter());
//     }
//   }

//   //Open all boxes
//   Future<void> _openBoxes() async {
//     await Hive.openBox<BatchHiveModel>(HiveTableConstant.batchTable);
//   }

//   //Create a new batch
//   Future<BatchHiveModel> createBatch(BatchHiveModel batch) async {
//     await _batchBox.put(batch.batchId, batch);
//     return batch;
//   }

//   //Get all batches
//   List<BatchHiveModel> getAllBatches() {
//     return _batchBox.values.toList();
//   }

//   //Get batch by ID
//   Future<BatchHiveModel> getBatchById(String batchId) {
//     final batch = _batchBox.get(batchId);
//     if (batch == null) {
//       throw Exception('Batch with ID $batchId not found');
//     }
//     return Future.value(batch);
//   }

//   //Update a batch
//   Future<void> updateBatch(BatchHiveModel batch) async {
//     await _batchBox.put(batch.batchId, batch);
//   }

//   //Delete a batch
//   Future<void> deleteBatch(String batchId) async {
//     await _batchBox.delete(batchId);
//   }

//   //Delete all batches
//   Future<void> deleteAllBatches() async {
//     await _batchBox.clear();
//   }

//   //Close all boxes
//   Future<void> close() async {
//     await Hive.close();
//   }
// }
