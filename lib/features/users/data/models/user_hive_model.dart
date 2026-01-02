import 'package:businesstrack/core/constants/hive_table_constant.dart';
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

  UserHiveModel({String? userId, required this.username, String? status})
    : userId = userId ?? const Uuid().v4(),
      status = status ?? 'active';

  // Convert Model to Batch Entity
  UserEntity toEntity() {
    return UserEntity(userId: userId, username: username, status: status);
  }

  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(username: entity.username);
  }

  // Convert list of models to list of entities
  static List<UserEntity> toEntityList(List<UserHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
