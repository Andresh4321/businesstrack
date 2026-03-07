import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String? status;

  @HiveField(3)
  final String? fullname;

  @HiveField(4)
  final String? email;

  @HiveField(5)
  final String? phoneNumber;

  @HiveField(6)
  final String? profileImage;

  @HiveField(7)
  final DateTime? createdAt;

  @HiveField(8)
  final DateTime? updatedAt;

  UserHiveModel({
    String? userId,
    required this.username,
    String? status,
    this.fullname,
    this.email,
    this.phoneNumber,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  }) : userId = userId ?? const Uuid().v4(),
       status = status ?? 'active';

  // Convert Model to Batch Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      username: username,
      status: status,
      fullname: fullname,
      email: email,
      phoneNumber: phoneNumber,
      profileImage: profileImage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      username: entity.username,
      fullname: entity.fullname,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      profileImage: entity.profileImage,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Convert list of models to list of entities
  static List<UserEntity> toEntityList(List<UserHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}

@HiveType(typeId: 13)
class AIAssistantHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String query;

  @HiveField(3)
  final String response;

  @HiveField(4)
  final DateTime createdAt;

  AIAssistantHiveModel({
    String? id,
    required this.userId,
    required this.query,
    required this.response,
    required this.createdAt,
  }) : id = id ?? const Uuid().v4();

  /// From Entity
  factory AIAssistantHiveModel.fromEntity(AIAssistantEntity entity) {
    return AIAssistantHiveModel(
      id: entity.id,
      userId: entity.userId,
      query: entity.query,
      response: entity.response,
      createdAt: entity.createdAt,
    );
  }

  /// To Entity
  AIAssistantEntity toEntity() {
    return AIAssistantEntity(
      id: id,
      userId: userId,
      query: query,
      response: response,
      createdAt: createdAt,
    );
  }
}
