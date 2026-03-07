import 'package:businesstrack/core/services/hive/Hive_Service.dart';
import 'package:businesstrack/features/users/data/datasources/user_datasource.dart';
import 'package:businesstrack/features/users/data/models/user_hive_model.dart';
import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userLocalDataSourceProvider = Provider<IUserDataSource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return UserLocalDataSourceImpl(hiveService: hiveService);
});

class UserLocalDataSourceImpl implements IUserDataSource {
  final HiveService hiveService;

  UserLocalDataSourceImpl({required this.hiveService});

  @override
  Future<UserEntity?> getUserProfile(String userId) async {
    try {
      final userModel = await hiveService.getuserById(userId);
      return userModel.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<AIAssistantEntity>?> getAIAssistantHistory(String userId) async {
    // No local Hive cache wired up for AI assistant history yet.
    return null;
  }

  @override
  Future<List<NotificationEntity>?> getNotifications(String userId) async {
    // No local Hive cache wired up for notifications yet.
    return null;
  }
}
