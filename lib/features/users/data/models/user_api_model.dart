import 'package:businesstrack/features/users/domain/entities/user_entity.dart';

class UserApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserApiModel({
    this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  // Convert JSON → API Model
  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      id: json['_id'] as String?,
      fullName: json['fullname'] as String? ?? json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber:
          json['phone_number'] as String? ?? json['phoneNumber'] as String?,
      profileImage:
          json['profileImage'] as String? ?? json['profilePicture'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // Convert API Model → JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "fullname": fullName,
      "email": email,
      "phone_number": phoneNumber,
      "profileImage": profileImage,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }

  // Convert API Model → Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: id,
      username: fullName,
      fullname: fullName,
      email: email,
      phoneNumber: phoneNumber,
      profileImage: profileImage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Convert Entity → API Model
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      id: entity.userId,
      fullName: entity.fullname ?? entity.username,
      email: entity.email ?? '',
      phoneNumber: entity.phoneNumber,
      profileImage: entity.profileImage,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

class NotificationApiModel {
  final String? id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  NotificationApiModel({
    this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  // Convert JSON → API Model
  factory NotificationApiModel.fromJson(Map<String, dynamic> json) {
    return NotificationApiModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Convert API Model → Entity
  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id ?? '',
      userId: userId,
      title: title,
      message: message,
      type: type,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}

class AIAssistantApiModel {
  final String? id;
  final String userId;
  final String query;
  final String response;
  final DateTime createdAt;

  AIAssistantApiModel({
    this.id,
    required this.userId,
    required this.query,
    required this.response,
    required this.createdAt,
  });

  // Convert JSON → API Model
  factory AIAssistantApiModel.fromJson(Map<String, dynamic> json) {
    return AIAssistantApiModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String,
      query: json['query'] as String,
      response: json['response'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Convert API Model → Entity
  AIAssistantEntity toEntity() {
    return AIAssistantEntity(
      id: id ?? '',
      userId: userId,
      query: query,
      response: response,
      createdAt: createdAt,
    );
  }
}
