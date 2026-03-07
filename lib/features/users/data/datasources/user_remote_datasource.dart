import 'package:businesstrack/core/error/exceptions.dart';
import 'package:businesstrack/features/users/data/models/user_api_model.dart';
import 'package:dio/dio.dart';

abstract interface class IUserRemoteDataSource {
  Future<UserApiModel> getUserProfile();

  Future<void> updateUserProfile({
    required String fullName,
    String? phoneNumber,
    String? profileImage,
  });

  Future<String> queryAIAssistant(String query);

  Future<List<AIAssistantApiModel>> getAIAssistantHistory();
}

class UserRemoteDataSource implements IUserRemoteDataSource {
  final Dio dio;
  final String baseUrl = '/api/auth';
  final String aiBaseUrl = '/api/ai-assistant'; // Future endpoint

  UserRemoteDataSource({required this.dio});

  @override
  Future<UserApiModel> getUserProfile() async {
    try {
      final response = await dio.get('$baseUrl/whoami');

      if (response.statusCode == 200) {
        return UserApiModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }
      throw ServerException('Failed to get user profile');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }

  @override
  Future<void> updateUserProfile({
    required String fullName,
    String? phoneNumber,
    String? profileImage,
  }) async {
    try {
      final data = {
        'fullname': fullName,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (profileImage != null) 'profileImage': profileImage,
      };

      final response = await dio.put('$baseUrl/profile', data: data);

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Failed to update profile',
        );
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }

  @override
  Future<String> queryAIAssistant(String query) async {
    try {
      // This endpoint may need to be implemented in the backend
      // Currently using a stub for future implementation
      final response = await dio.post(
        '$aiBaseUrl/query',
        data: {'query': query},
      );

      if (response.statusCode == 200) {
        return response.data['data']['response'] as String;
      }
      throw ServerException('Failed to query AI assistant');
    } on DioException catch (e) {
      // Return a placeholder response if endpoint doesn't exist yet
      if (e.response?.statusCode == 404) {
        return 'AI Assistant is coming soon!';
      }
      throw ServerException(e.message ?? 'Server error');
    }
  }

  @override
  Future<List<AIAssistantApiModel>> getAIAssistantHistory() async {
    try {
      // This endpoint may need to be implemented in the backend
      final response = await dio.get('$aiBaseUrl/history');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data
            .map((h) => AIAssistantApiModel.fromJson(h as Map<String, dynamic>))
            .toList();
      }
      throw ServerException('Failed to get AI history');
    } on DioException catch (e) {
      // Return empty list if endpoint doesn't exist yet
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw ServerException(e.message ?? 'Server error');
    }
  }
}
