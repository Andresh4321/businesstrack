import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IUserRepository {
  Future<Either<Failure, UserEntity>> getUserProfile(String userId);

  Future<Either<Failure, UserEntity>> updateUserProfile(UserEntity user);

  Future<Either<Failure, AIAssistantEntity>> queryAIAssistant(
    String userId,
    String query,
  );

  Future<Either<Failure, List<AIAssistantEntity>>> getAIAssistantHistory(
    String userId,
  );

  Future<Either<Failure, List<NotificationEntity>>> getNotifications(
    String userId,
  );
}
