import 'package:businesstrack/core/error/exceptions.dart';
import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/users/data/datasources/user_datasource.dart';
import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:businesstrack/features/users/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';

class UserRepositoryImpl implements IUserRepository {
  final IUserDataSource localDataSource;
  final IUserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> getUserProfile(String userId) async {
    try {
      // Try local cache first
      var user = await localDataSource.getUserProfile(userId);

      if (user != null) {
        return Right(user);
      }

      // Fetch from remote if not cached
      user = await remoteDataSource.getUserProfile(userId);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile(UserEntity user) async {
    try {
      final result = await remoteDataSource.updateUserProfile(user);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, AIAssistantEntity>> queryAIAssistant(
    String userId,
    String query,
  ) async {
    try {
      final result = await remoteDataSource.queryAIAssistant(userId, query);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<AIAssistantEntity>>> getAIAssistantHistory(
    String userId,
  ) async {
    try {
      // Try local cache first
      var history = await localDataSource.getAIAssistantHistory(userId);

      if (history != null && history.isNotEmpty) {
        return Right(history);
      }

      // Fetch from remote if cache is empty
      history = await remoteDataSource.getAIAssistantHistory(userId);
      return Right(history);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications(
    String userId,
  ) async {
    try {
      // Try local cache first
      var notifications = await localDataSource.getNotifications(userId);

      if (notifications != null && notifications.isNotEmpty) {
        return Right(notifications);
      }

      // Fetch from remote if cache is empty
      notifications = await remoteDataSource.getNotifications(userId);
      return Right(notifications);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
