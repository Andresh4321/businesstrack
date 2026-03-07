import 'package:businesstrack/core/error/exceptions.dart';
import 'package:businesstrack/features/users/data/datasources/user_datasource.dart';
import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:dio/dio.dart';

class UserRemoteDataSourceImpl implements IUserRemoteDataSource {
  final Dio dio;
  final String baseUrl = '/api/auth';
  final String aiBaseUrl = '/api/ai-assistant';

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserEntity> getUserProfile(String userId) async {
    try {
      final response = await dio.get('$baseUrl/profile/$userId');

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        return UserEntity(
          userId: data['userId'] as String,
          username: data['username'] as String,
          email: data['email'] as String?,
          fullname: data['fullname'] as String?,
          phoneNumber: data['phoneNumber'] as String?,
          profileImage: data['profileImage'] as String?,
          status: data['status'] as String? ?? 'active',
          createdAt: data['createdAt'] != null
              ? DateTime.parse(data['createdAt'] as String)
              : null,
          updatedAt: data['updatedAt'] != null
              ? DateTime.parse(data['updatedAt'] as String)
              : null,
        );
      }
      throw ServerException('Failed to get user profile');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }

  @override
  Future<UserEntity> updateUserProfile(UserEntity user) async {
    try {
      final data = {
        'fullname': user.fullname,
        if (user.phoneNumber != null) 'phoneNumber': user.phoneNumber,
        if (user.profileImage != null) 'profileImage': user.profileImage,
      };

      final response = await dio.put('$baseUrl/profile', data: data);

      if (response.statusCode == 200) {
        final responseData = response.data['data'] as Map<String, dynamic>;
        return UserEntity(
          userId: responseData['userId'] as String,
          username: responseData['username'] as String,
          email: responseData['email'] as String?,
          fullname: responseData['fullname'] as String?,
          phoneNumber: responseData['phoneNumber'] as String?,
          profileImage: responseData['profileImage'] as String?,
          status: responseData['status'] as String? ?? 'active',
          createdAt: responseData['createdAt'] != null
              ? DateTime.parse(responseData['createdAt'] as String)
              : null,
          updatedAt: responseData['updatedAt'] != null
              ? DateTime.parse(responseData['updatedAt'] as String)
              : null,
        );
      }
      throw ServerException(
        response.data['message'] ?? 'Failed to update profile',
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }

  @override
  Future<AIAssistantEntity> queryAIAssistant(
    String userId,
    String query,
  ) async {
    try {
      final response = await dio.post(
        '$aiBaseUrl/query',
        data: {'userId': userId, 'query': query},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        return AIAssistantEntity(
          id: data['id'] as String,
          userId: userId,
          query: data['query'] as String,
          response: data['response'] as String,
          createdAt: DateTime.parse(data['createdAt'] as String),
        );
      }
      throw ServerException('Failed to query AI assistant');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException('AI Assistant endpoint not available');
      }
      throw ServerException(e.message ?? 'Server error');
    }
  }

  @override
  Future<List<AIAssistantEntity>> getAIAssistantHistory(String userId) async {
    try {
      final response = await dio.get('$aiBaseUrl/history/$userId');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((h) {
          final item = h as Map<String, dynamic>;
          return AIAssistantEntity(
            id: item['id'] as String,
            userId: userId,
            query: item['query'] as String,
            response: item['response'] as String,
            createdAt: DateTime.parse(item['createdAt'] as String),
          );
        }).toList();
      }
      throw ServerException('Failed to get AI history');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw ServerException(e.message ?? 'Server error');
    }
  }

  @override
  Future<List<NotificationEntity>> getNotifications(String userId) async {
    try {
      final response = await dio.get('/api/notifications/$userId');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((n) {
          final item = n as Map<String, dynamic>;
          return NotificationEntity(
            id: item['id'] as String,
            userId: userId,
            title: item['title'] as String,
            message: item['message'] as String,
            type: item['type'] as String,
            isRead: item['isRead'] as bool? ?? false,
            createdAt: DateTime.parse(item['createdAt'] as String),
          );
        }).toList();
      }
      throw ServerException('Failed to get notifications');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw ServerException(e.message ?? 'Server error');
    }
  }
}
