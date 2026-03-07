import 'package:businesstrack/core/api/api_client.dart';
import 'package:businesstrack/core/api/api_endpoints.dart';
import 'package:businesstrack/core/error/exceptions.dart';
import 'package:businesstrack/features/messaging/data/datasources/messaging_datasource.dart';
import 'package:businesstrack/features/messaging/data/models/message_api_model.dart';
import 'package:businesstrack/features/messaging/domain/entities/message_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagingRemoteDataSourceProvider = Provider<IMessagingRemoteDataSource>((
  ref,
) {
  return MessagingRemoteDataSource(apiClient: ref.read(apiClientProvider));
});

class MessagingRemoteDataSource implements IMessagingRemoteDataSource {
  final ApiClient _apiClient;

  MessagingRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<bool> checkUserExists(String email) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.messagesCheckUser,
        data: {'email': email},
      );
      return response.data['success'] == true;
    } on DioException catch (e) {
      // Backend returns 404 for "does not exist".
      if (e.response?.statusCode == 404) return false;
      throw ServerException(e.message ?? 'Server error');
    }
  }

  @override
  Future<ConversationEntity> getOrCreateConversation(String receiverEmail) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.messagesConversation,
        data: {'receiverEmail': receiverEmail},
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return ConversationApiModel.fromJson(data).toEntity();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MessageEntity> sendMessage({
    required String receiverId,
    required String conversationId,
    required String message,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.messagesSend,
        data: {
          'receiverId': receiverId,
          'conversationId': conversationId,
          'message': message,
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return MessageApiModel.fromJson(data).toEntity();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MessageEntity>> getConversation(String conversationId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.messagesByConversationId(conversationId),
      );

      final data = response.data['data'] as List;
      return data
          .map((m) => MessageApiModel.fromJson(m as Map<String, dynamic>))
          .map((m) => m.toEntity())
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ConversationEntity>> getConversationsList() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.messages);
      final data = response.data['data'] as List;
      return data
          .map((c) => ConversationApiModel.fromJson(c as Map<String, dynamic>))
          .map((c) => c.toEntity())
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.messagesUnreadCount);
      final data = response.data['data'] as Map<String, dynamic>? ?? const {};
      return (data['unreadCount'] as int?) ?? 0;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MessageNotificationEntity>> getNotifications() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.messagesNotifications);
      final data = response.data['data'] as List;
      return data
          .map(
            (n) =>
                MessageNotificationApiModel.fromJson(n as Map<String, dynamic>),
          )
          .map((n) => n.toEntity())
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

