import 'package:businesstrack/core/api/api_client.dart';
import 'package:businesstrack/core/api/api_endpoints.dart';
import 'package:businesstrack/core/services/storage/token_service.dart';
import 'package:businesstrack/core/services/storage/user_session_service.dart';
import 'package:businesstrack/features/auth/data/datasource/auth_datasource.dart';
import 'package:businesstrack/features/auth/data/models/auth_hive_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:businesstrack/features/auth/data/models/auth_api_model.dart';

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
        ApiEndpoints.studentLogin,
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
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel> register(AuthApiModel model) async {
    final response = await _apiClient.post(
      ApiEndpoints.studentRegister,
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
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
