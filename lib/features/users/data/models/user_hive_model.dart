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

  UserHiveModel({
    String? userId,
    required this.username,
    String? status,
    this.fullname,
    this.email,
    this.phoneNumber,
    this.profileImage,
  })  : userId = userId ?? const Uuid().v4(),
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
    );
  }

  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      username: entity.username,
      fullname: entity.fullname,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      profileImage: entity.profileImage,
    );
  }

  // Convert list of models to list of entities
  static List<UserEntity> toEntityList(List<UserHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
