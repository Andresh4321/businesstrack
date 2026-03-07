import 'package:businesstrack/features/messaging/domain/entities/message_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'message_hive_model.g.dart';

@HiveType(typeId: 10)
class MessageHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String senderId;

  @HiveField(2)
  final String senderName;

  @HiveField(3)
  final String senderEmail;

  @HiveField(4)
  final String receiverId;

  @HiveField(5)
  final String receiverName;

  @HiveField(6)
  final String receiverEmail;

  @HiveField(7)
  final String conversationId;

  @HiveField(8)
  final String message;

  @HiveField(9)
  final bool isRead;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final DateTime updatedAt;

  MessageHiveModel({
    String? id,
    required this.senderId,
    required this.senderName,
    required this.senderEmail,
    required this.receiverId,
    required this.receiverName,
    required this.receiverEmail,
    required this.conversationId,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  }) : id = id ?? const Uuid().v4();

  /// From Entity
  factory MessageHiveModel.fromEntity(MessageEntity entity) {
    return MessageHiveModel(
      id: entity.id,
      senderId: entity.senderId,
      senderName: entity.senderName,
      senderEmail: entity.senderEmail,
      receiverId: entity.receiverId,
      receiverName: entity.receiverName,
      receiverEmail: entity.receiverEmail,
      conversationId: entity.conversationId,
      message: entity.message,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// To Entity
  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      senderId: senderId,
      senderName: senderName,
      senderEmail: senderEmail,
      receiverId: receiverId,
      receiverName: receiverName,
      receiverEmail: receiverEmail,
      conversationId: conversationId,
      message: message,
      isRead: isRead,
      // Hive cache doesn't persist `isMine`; derive it at runtime if needed.
      isMine: false,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

@HiveType(typeId: 11)
class ConversationHiveModel extends HiveObject {
  @HiveField(0)
  final String conversationId;

  @HiveField(1)
  final String receiverId;

  @HiveField(2)
  final String receiverName;

  @HiveField(3)
  final String receiverEmail;

  @HiveField(4)
  final String lastMessage;

  @HiveField(5)
  final DateTime lastMessageTime;

  @HiveField(6)
  final int unreadCount;

  ConversationHiveModel({
    required this.conversationId,
    required this.receiverId,
    required this.receiverName,
    required this.receiverEmail,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  /// From Entity
  factory ConversationHiveModel.fromEntity(ConversationEntity entity) {
    return ConversationHiveModel(
      conversationId: entity.conversationId,
      receiverId: entity.otherUserId,
      receiverName: entity.otherUserName,
      receiverEmail: entity.otherUserEmail,
      lastMessage: entity.lastMessage ?? '',
      lastMessageTime: entity.lastMessageTime ?? DateTime.now(),
      unreadCount: entity.unread == true ? 1 : 0,
    );
  }

  /// To Entity
  ConversationEntity toEntity() {
    return ConversationEntity(
      conversationId: conversationId,
      otherUserId: receiverId,
      otherUserName: receiverName,
      otherUserEmail: receiverEmail,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      unread: unreadCount > 0,
    );
  }
}
