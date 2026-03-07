import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:businesstrack/features/users/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserProfileUsecase {
  final IUserRepository repository;

  GetUserProfileUsecase({required this.repository});

  Future<Either<Failure, UserEntity>> call(String userId) {
    return repository.getUserProfile(userId);
  }
}

class UpdateUserProfileUsecase {
  final IUserRepository repository;

  UpdateUserProfileUsecase({required this.repository});

  Future<Either<Failure, UserEntity>> call(UserEntity user) {
    return repository.updateUserProfile(user);
  }
}

class QueryAIAssistantUsecase {
  final IUserRepository repository;

  QueryAIAssistantUsecase({required this.repository});

  Future<Either<Failure, AIAssistantEntity>> call(String userId, String query) {
    return repository.queryAIAssistant(userId, query);
  }
}

class GetAIAssistantHistoryUsecase {
  final IUserRepository repository;

  GetAIAssistantHistoryUsecase({required this.repository});

  Future<Either<Failure, List<AIAssistantEntity>>> call(String userId) {
    return repository.getAIAssistantHistory(userId);
  }
}

class GetNotificationsUsecase {
  final IUserRepository repository;

  GetNotificationsUsecase({required this.repository});

  Future<Either<Failure, List<NotificationEntity>>> call(String userId) {
    return repository.getNotifications(userId);
  }
}
