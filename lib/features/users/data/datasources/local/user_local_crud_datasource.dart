import 'package:businesstrack/core/services/hive/Hive_Service.dart';
import 'package:businesstrack/features/users/data/models/user_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Local (Hive) datasource used by the legacy CRUD-style users feature.
///
/// This is intentionally separate from `IUserDataSource` (profile/AI feature)
/// to avoid mixing two different user modules that currently coexist.
abstract class IUserDatasource {
  Future<bool> createuser(UserHiveModel user);
  Future<bool> updateuser(UserHiveModel user);
  Future<bool> deleteuser(String userId);

  Future<List<UserHiveModel>> getAllusers();
  Future<UserHiveModel> getuserById(String userId);
}

final userLocalDatasourceProvider = Provider<IUserDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return UserLocalCrudDatasource(hiveService: hiveService);
});

class UserLocalCrudDatasource implements IUserDatasource {
  final HiveService hiveService;

  UserLocalCrudDatasource({required this.hiveService});

  @override
  Future<bool> createuser(UserHiveModel user) async {
    await hiveService.createuser(user);
    return true;
  }

  @override
  Future<bool> updateuser(UserHiveModel user) async {
    await hiveService.updateuser(user);
    return true;
  }

  @override
  Future<bool> deleteuser(String userId) async {
    await hiveService.deleteuser(userId);
    return true;
  }

  @override
  Future<List<UserHiveModel>> getAllusers() async {
    // Hive read is synchronous; keep the signature async for interface parity.
    return hiveService.getAlluseres();
  }

  @override
  Future<UserHiveModel> getuserById(String userId) {
    return hiveService.getuserById(userId);
  }
}
