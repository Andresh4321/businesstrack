import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/messaging/domain/entities/message_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IMessagingRepository {
  Future<Either<Failure, bool>> checkUserExists(String email);

  Future<Either<Failure, ConversationEntity>> getOrCreateConversation(
    String receiverEmail,
  );

  Future<Either<Failure, MessageEntity>> sendMessage({
    required String receiverId,
    required String conversationId,
    required String message,
  });

  Future<Either<Failure, List<MessageEntity>>> getConversation(
    String conversationId,
  );

  Future<Either<Failure, List<ConversationEntity>>> getConversationsList();

  Future<Either<Failure, int>> getUnreadCount();

  Future<Either<Failure, List<MessageNotificationEntity>>> getNotifications();
}

