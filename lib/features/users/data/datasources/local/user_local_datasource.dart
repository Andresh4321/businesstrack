
import 'package:businesstrack/core/services/hive/Hive_Service.dart';
import 'package:businesstrack/features/users/data/datasources/user_datasource.dart';
import 'package:businesstrack/features/users/data/models/user_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userLocalDatasourceProvider = Provider<UserLocalDatasource>((ref) {
  return UserLocalDatasource(hiveService: ref.read(hiveServiceProvider));
});


class UserLocalDatasource implements IUserDatasource {
  //dependency injection

  final HiveService _hiveService;

  UserLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;
    
      @override
      Future<bool> createuser(UserHiveModel user) {
    // TODO: implement createBatch
    throw UnimplementedError();
      }
    
      @override
      Future<bool> deleteuser(String userId) {
    // TODO: implement deleteBatch
    throw UnimplementedError();
      }
    
      @override
      Future<List<UserHiveModel>> getAllusers() {
    // TODO: implement getAllBactches
    throw UnimplementedError();
      }
    
      @override
      Future<UserHiveModel> getuserById(String userId) {
    // TODO: implement getBatchById
    throw UnimplementedError();
      }
    
      @override
      Future<bool> updateuser(UserHiveModel user) {
    // TODO: implement updateBatch
    throw UnimplementedError();
      }

}
