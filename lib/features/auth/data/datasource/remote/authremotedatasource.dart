import 'package:businesstrack/core/api/api_client.dart';
import 'package:businesstrack/core/api/api_endpoints.dart';
import 'package:businesstrack/core/services/storage/token_service.dart';
import 'package:businesstrack/core/services/storage/user_session_service.dart';
import 'package:businesstrack/features/auth/data/datasource/auth_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:businesstrack/features/auth/data/models/auth_api_model.dart';
import 'package:dio/dio.dart';

final authRemoteProvider = Provider<IAuthRemoteDataSource>((ref) {
  return Authremotedatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class Authremotedatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  Authremotedatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenService = tokenService;

  @override
  Future<bool> deleteUser(String authId) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel?> getUserByEmail(String email) {
    // TODO: implement getUserByEmail
    throw UnimplementedError();
  }

  @override
  Future<bool> isEmailExists(String email) {
    // TODO: implement isEmailExists
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.authLogin,
        data: {'email': email, 'password': password},
      );
      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final user = AuthApiModel.fromJson(data); // ✅ JSON → API Model

        //save to session
        await _userSessionService.saveUserSession(
          userId: user.id!,
          email: user.email,
          fullName: user.fullName,
        );
        //save token
        final token = response.data['token'] as String?;
        await _tokenService.saveToken(token!);
        return user;
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  @override
  Future<AuthApiModel?> adminLogin(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.authAdminLogin,
        data: {'email': email, 'password': password},
      );
      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final user = AuthApiModel.fromJson(data);

        await _userSessionService.saveUserSession(
          userId: user.id!,
          email: user.email,
          fullName: user.fullName,
        );

        final token = response.data['token'] as String?;
        if (token != null) {
          await _tokenService.saveToken(token);
        }
        return user;
      }
      return null;
    } catch (e) {
      print('Admin login error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel> register(AuthApiModel model) async {
    final response = await _apiClient.post(
      ApiEndpoints.authRegister,
      data: model.toJson(),
    );
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registerUser = AuthApiModel.fromJson(data); // ✅ JSON → API Model

      return registerUser;
    }
    return model;
  }

  @override
  Future<bool> updateUser(AuthApiModel model) {
    return _updateUserInternal(model);
  }

  Future<bool> _updateUserInternal(AuthApiModel model) async {
    try {
      final id = model.id;
      if (id == null || id.trim().isEmpty) {
        return false;
      }
      final response = await _apiClient.put(
        ApiEndpoints.authUpdateProfile(id),
        data: model.toJson(),
      );
      if (response.data is Map && response.data['success'] == true) {
        final data = response.data['data'];
        if (data is Map<String, dynamic>) {
          final updated = AuthApiModel.fromJson(data);
          await _userSessionService.saveUserSession(
            userId: updated.id ?? id,
            email: updated.email,
            fullName: updated.fullName,
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Update user error: $e');
      rethrow;
    }
  }

  @override
  Future<AuthApiModel?> whoAmI() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.authWhoAmI);
      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final user = AuthApiModel.fromJson(data);
        await _userSessionService.saveUserSession(
          userId: user.id ?? '',
          email: user.email,
          fullName: user.fullName,
        );
        return user;
      }
      return null;
    } catch (e) {
      print('WhoAmI error: $e');
      rethrow;
    }
  }

  @override
  Future<String?> uploadPhoto(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await _apiClient.uploadFile(
        ApiEndpoints.authUploadPhoto,
        formData: formData,
      );

      if (response.data is Map && response.data['success'] == true) {
        final data = response.data['data'];
        if (data is Map && data['fileName'] is String) {
          return data['fileName'] as String;
        }
        if (data is Map && data['url'] is String) {
          return data['url'] as String;
        }
      }

      final responseData = response.data;
      if (responseData is Map && responseData['fileName'] is String) {
        return responseData['fileName'] as String;
      }
      if (responseData is Map && responseData['url'] is String) {
        return responseData['url'] as String;
      }

      return null;
    } catch (e) {
      print('Upload photo error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.authForgotPassword,
        data: {'email': email},
      );
      return response.data is Map && response.data['success'] == true;
    } catch (e) {
      print('Forgot password error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> resetPassword(String token, String newPassword) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.authResetPassword(token),
        data: {'password': newPassword},
      );
      return response.data is Map && response.data['success'] == true;
    } catch (e) {
      print('Reset password error: $e');
      rethrow;
    }
  }
}
