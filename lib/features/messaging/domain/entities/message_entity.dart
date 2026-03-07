import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
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

  const MessageEntity({
    required this.id,
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

  @override
  List<Object?> get props => [
    id,
    senderId,
    senderName,
    senderEmail,
    receiverId,
    receiverName,
    receiverEmail,
    conversationId,
    message,
    isRead,
    isMine,
    createdAt,
    updatedAt,
  ];
}

class ConversationEntity extends Equatable {
  final String conversationId;
  final String otherUserId;
  final String otherUserName;
  final String otherUserEmail;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final bool? unread;

  const ConversationEntity({
    required this.conversationId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserEmail,
    this.lastMessage,
    this.lastMessageTime,
    this.unread,
  });

  @override
  List<Object?> get props => [
    conversationId,
    otherUserId,
    otherUserName,
    otherUserEmail,
    lastMessage,
    lastMessageTime,
    unread,
  ];
}

class MessageNotificationEntity extends Equatable {
  final String senderId;
  final String senderName;
  final String senderEmail;
  final String conversationId;
  final String lastMessage;
  final DateTime createdAt;
  final int messageCount;

  const MessageNotificationEntity({
    required this.senderId,
    required this.senderName,
    required this.senderEmail,
    required this.conversationId,
    required this.lastMessage,
    required this.createdAt,
    required this.messageCount,
  });

  @override
  List<Object?> get props => [
    senderId,
    senderName,
    senderEmail,
    conversationId,
    lastMessage,
    createdAt,
    messageCount,
  ];
}
