import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String username;
  final String? status;
  final String? fullname;
  final String? email;
  final String? phoneNumber;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    this.userId,
    required this.username,
    this.status,
    this.fullname,
    this.email,
    this.phoneNumber,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    userId,
    username,
    status,
    fullname,
    email,
    phoneNumber,
    profileImage,
    createdAt,
    updatedAt,
  ];
}

class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // 'message', 'alert', 'system'
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    message,
    type,
    isRead,
    createdAt,
  ];
}

class AIAssistantEntity extends Equatable {
  final String id;
  final String userId;
  final String query;
  final String response;
  final DateTime createdAt;

  const AIAssistantEntity({
    required this.id,
    required this.userId,
    required this.query,
    required this.response,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, query, response, createdAt];
}
