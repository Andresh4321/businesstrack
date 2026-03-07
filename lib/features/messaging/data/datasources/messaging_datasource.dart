import 'package:businesstrack/features/messaging/domain/entities/message_entity.dart';

abstract interface class IMessagingRemoteDataSource {
  Future<bool> checkUserExists(String email);

  Future<ConversationEntity> getOrCreateConversation(String receiverEmail);

  Future<MessageEntity> sendMessage({
    required String receiverId,
    required String conversationId,
    required String message,
  });

  Future<List<MessageEntity>> getConversation(String conversationId);

  Future<List<ConversationEntity>> getConversationsList();

  Future<int> getUnreadCount();

  Future<List<MessageNotificationEntity>> getNotifications();
}

