import '../../domain/entities/user_entity.dart';

abstract class IUserDataSource {
  Future<UserEntity?> getUserProfile(String userId);
  Future<List<AIAssistantEntity>?> getAIAssistantHistory(String userId);
  Future<List<NotificationEntity>?> getNotifications(String userId);
}

abstract class IUserRemoteDataSource {
  Future<UserEntity> getUserProfile(String userId);
  Future<UserEntity> updateUserProfile(UserEntity user);
  Future<AIAssistantEntity> queryAIAssistant(String userId, String query);
  Future<List<AIAssistantEntity>> getAIAssistantHistory(String userId);
  Future<List<NotificationEntity>> getNotifications(String userId);
}
