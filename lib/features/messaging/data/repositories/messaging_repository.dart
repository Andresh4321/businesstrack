import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/services/connectivity/network_info.dart';
import 'package:businesstrack/features/messaging/data/datasources/messaging_datasource.dart';
import 'package:businesstrack/features/messaging/data/datasources/messaging_remote_datasource.dart';
import 'package:businesstrack/features/messaging/domain/entities/message_entity.dart';
import 'package:businesstrack/features/messaging/domain/repository/messaging_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagingRepositoryProvider = Provider<IMessagingRepository>((ref) {
  return MessagingRepository(
    remoteDataSource: ref.read(messagingRemoteDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class MessagingRepository implements IMessagingRepository {
  final IMessagingRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  MessagingRepository({
    required IMessagingRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> checkUserExists(String email) async {
    if (!await _networkInfo.isConnected) {
      return Left(Apifailure(message: 'No internet connection'));
    }

    try {
      final result = await _remoteDataSource.checkUserExists(email);
      return Right(result);
    } catch (e) {
      return Left(Apifailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConversationEntity>> getOrCreateConversation(
    String receiverEmail,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(Apifailure(message: 'No internet connection'));
    }

    try {
      final conversation = await _remoteDataSource.getOrCreateConversation(
        receiverEmail,
      );
      return Right(conversation);
    } catch (e) {
      return Left(Apifailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String receiverId,
    required String conversationId,
    required String message,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(Apifailure(message: 'No internet connection'));
    }

    try {
      final sent = await _remoteDataSource.sendMessage(
        receiverId: receiverId,
        conversationId: conversationId,
        message: message,
      );
      return Right(sent);
    } catch (e) {
      return Left(Apifailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getConversation(
    String conversationId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(Apifailure(message: 'No internet connection'));
    }

    try {
      final messages = await _remoteDataSource.getConversation(conversationId);
      return Right(messages);
    } catch (e) {
      return Left(Apifailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversationsList() async {
    if (!await _networkInfo.isConnected) {
      return Left(Apifailure(message: 'No internet connection'));
    }

    try {
      final conversations = await _remoteDataSource.getConversationsList();
      return Right(conversations);
    } catch (e) {
      return Left(Apifailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    if (!await _networkInfo.isConnected) {
      return Left(Apifailure(message: 'No internet connection'));
    }

    try {
      final count = await _remoteDataSource.getUnreadCount();
      return Right(count);
    } catch (e) {
      return Left(Apifailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageNotificationEntity>>> getNotifications() async {
    if (!await _networkInfo.isConnected) {
      return Left(Apifailure(message: 'No internet connection'));
    }

    try {
      final notifications = await _remoteDataSource.getNotifications();
      return Right(notifications);
    } catch (e) {
      return Left(Apifailure(message: e.toString()));
    }
  }
}

