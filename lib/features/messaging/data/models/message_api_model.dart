import 'package:businesstrack/features/messaging/domain/entities/message_entity.dart';

class MessageApiModel {
  final String? id;
  final String senderId;
  final String senderName;
  final String senderEmail;
  final String receiverId;
  final String receiverName;
  final String receiverEmail;
  final String conversationId;
  final String message;
  final bool isRead;
  final bool isMine;
  final DateTime createdAt;
  final DateTime updatedAt;

  MessageApiModel({
    this.id,
    required this.senderId,
    required this.senderName,
    required this.senderEmail,
    required this.receiverId,
    required this.receiverName,
    required this.receiverEmail,
    required this.conversationId,
    required this.message,
    required this.isRead,
    required this.isMine,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageApiModel.fromJson(Map<String, dynamic> json) {
    return MessageApiModel(
      id: json['_id'] as String?,
      senderId: json['senderId'] as String? ?? '',
      senderName: json['senderName'] as String? ?? '',
      senderEmail: json['senderEmail'] as String? ?? '',
      receiverId: json['receiverId'] as String? ?? '',
      receiverName: json['receiverName'] as String? ?? '',
      receiverEmail: json['receiverEmail'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? '',
      message: json['message'] as String? ?? '',
      isRead: json['isRead'] as bool? ?? false,
      isMine: json['isMine'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id ?? '',
      senderId: senderId,
      senderName: senderName,
      senderEmail: senderEmail,
      receiverId: receiverId,
      receiverName: receiverName,
      receiverEmail: receiverEmail,
      conversationId: conversationId,
      message: message,
      isRead: isRead,
      isMine: isMine,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class ConversationApiModel {
  final String conversationId;
  final String otherUserId;
  final String otherUserName;
  final String otherUserEmail;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final bool? unread;

  ConversationApiModel({
    required this.conversationId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserEmail,
    this.lastMessage,
    this.lastMessageTime,
    this.unread,
  });

  factory ConversationApiModel.fromJson(Map<String, dynamic> json) {
    final otherUserId = (json['otherUserId'] ?? json['receiverId']) as String?;
    final otherUserName =
        (json['otherUserName'] ?? json['receiverName']) as String?;
    final otherUserEmail =
        (json['otherUserEmail'] ?? json['receiverEmail']) as String?;

    return ConversationApiModel(
      conversationId: json['conversationId'] as String? ?? '',
      otherUserId: otherUserId ?? '',
      otherUserName: otherUserName ?? '',
      otherUserEmail: otherUserEmail ?? '',
      lastMessage: json['lastMessage'] as String?,
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'] as String)
          : null,
      unread: json['unread'] as bool?,
    );
  }

  ConversationEntity toEntity() {
    return ConversationEntity(
      conversationId: conversationId,
      otherUserId: otherUserId,
      otherUserName: otherUserName,
      otherUserEmail: otherUserEmail,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      unread: unread,
    );
  }
}

class MessageNotificationApiModel {
  final String senderId;
  final String senderName;
  final String senderEmail;
  final String conversationId;
  final String lastMessage;
  final DateTime createdAt;
  final int messageCount;

  MessageNotificationApiModel({
    required this.senderId,
    required this.senderName,
    required this.senderEmail,
    required this.conversationId,
    required this.lastMessage,
    required this.createdAt,
    required this.messageCount,
  });

  factory MessageNotificationApiModel.fromJson(Map<String, dynamic> json) {
    return MessageNotificationApiModel(
      senderId: (json['_id'] as String?) ?? (json['senderId'] as String? ?? ''),
      senderName: json['senderName'] as String? ?? '',
      senderEmail: json['senderEmail'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? '',
      lastMessage: json['lastMessage'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      messageCount: json['messageCount'] as int? ?? 0,
    );
  }

  MessageNotificationEntity toEntity() {
    return MessageNotificationEntity(
      senderId: senderId,
      senderName: senderName,
      senderEmail: senderEmail,
      conversationId: conversationId,
      lastMessage: lastMessage,
      createdAt: createdAt,
      messageCount: messageCount,
    );
  }
}

