import 'package:businesstrack/features/auth/data/models/auth_api_model.dart';
import 'package:businesstrack/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthDataSource {
  Future<bool> register(AuthHiveModel model);
  Future<AuthHiveModel?> login(String email, String password);
  Future<bool> updateUser(AuthHiveModel model);
  Future<bool> deleteUser(String authId);
  Future<AuthHiveModel?> getCurrentUser();
  Future<AuthHiveModel?> getUserByEmail(String email);
  Future<bool> logout();

  Future<bool> isEmailExists(String email);
}

abstract interface class IAuthRemoteDataSource {
  Future<AuthApiModel> register(AuthApiModel model);
  Future<AuthApiModel?> login(String email, String password);
  Future<bool> updateUser(AuthApiModel model);
  Future<bool> deleteUser(String authId);
  Future<AuthApiModel?> getCurrentUser();
  Future<AuthApiModel?> getUserByEmail(String email);
  Future<bool> logout();

  Future<bool> isEmailExists(String email);
}
