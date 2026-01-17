import 'dart:math';

import 'package:businesstrack/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? password;
  final String? confirmPassword;
  final String? profilePicture;

  AuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.password,
    this.confirmPassword,
    this.profilePicture,
  });

  // Convert Entity → API Model
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      id: entity.authId,
      fullName: entity.fullName,
      email: entity.email ?? "",
      phoneNumber: entity.phoneNumber,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      profilePicture: entity.profilePicture,
    );
  }

  // Convert JSON → API Model
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['_id'] as String?,
      fullName: json['fullname'] as String? ?? json['name'] as String,
      email: json['email'] as String,
      phoneNumber:
          json['phone_number'] as String? ?? json['phoneNumber'] as String?,
      profilePicture: json['profilePicture'] as String?,
    );
  }

  // Convert API Model → JSON
  Map<String, dynamic> toJson() {
    return {
      "fullname": fullName,
      "email": email,
      "phone_number": phoneNumber,
      "password": password,
      "confirmPassword": confirmPassword,
      "profilePicture": profilePicture,
    };
  }

  // Convert API Model → Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      confirmPassword: confirmPassword,
      profilePicture: profilePicture,
    );
  }
}
