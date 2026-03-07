import 'package:businesstrack/core/services/hive/Hive_Service.dart';
import 'package:businesstrack/features/auth/data/datasource/auth_datasource.dart';
import 'package:businesstrack/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create provider
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return AuthLocalDatasource(hiveService: hiveService);
});

class AuthLocalDatasource implements IAuthDataSource {
  final HiveService _hiveService;

  AuthLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final user = await _hiveService.loginUser(email, password);
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateUser(AuthHiveModel user) {
    return _hiveService.registerUser(user).then((_) => true);
  }

  @override
  Future<bool> deleteUser(String authId) {
    return _hiveService.logoutUser(authId).then((_) => true);
  }

  @override
  Future<AuthHiveModel?> getCurrentUser() {
    return Future.value(_hiveService.getCurrentUser());
  }

  @override
  Future<AuthHiveModel?> getUserByEmail(String email) {
    return Future.value(_hiveService.getUserByEmail(email));
  }

  @override
  Future<bool> logout() async {
    try {
      final current = _hiveService.getCurrentUser();
      if (current?.authId != null) {
        await _hiveService.logoutUser(current!.authId!);
      }
      return true;
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<bool> register(AuthHiveModel model) async {
    try {
      await _hiveService.registerUser(model);
      return true;
    } catch (e) {
      print("REGISTER ERROR: $e");
      return false;
    }
  }

  @override
  Future<bool> isEmailExists(String email) {
    try {
      final exists = _hiveService.isEmailExists(email);
      return Future.value(exists);
    } catch (e) {
      return Future.value(false);
    }
  }
}
