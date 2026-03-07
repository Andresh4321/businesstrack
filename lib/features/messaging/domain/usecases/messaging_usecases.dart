import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/messaging/data/repositories/messaging_repository.dart';
import 'package:businesstrack/features/messaging/domain/entities/message_entity.dart';
import 'package:businesstrack/features/messaging/domain/repository/messaging_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final checkUserExistsUsecaseProvider = Provider<CheckUserExistsUsecase>((ref) {
  final repository = ref.read(messagingRepositoryProvider);
  return CheckUserExistsUsecase(repository: repository);
});

final getOrCreateConversationUsecaseProvider =
    Provider<GetOrCreateConversationUsecase>((ref) {
      final repository = ref.read(messagingRepositoryProvider);
      return GetOrCreateConversationUsecase(repository: repository);
    });

final sendMessageUsecaseProvider = Provider<SendMessageUsecase>((ref) {
  final repository = ref.read(messagingRepositoryProvider);
  return SendMessageUsecase(repository: repository);
});

final getConversationUsecaseProvider = Provider<GetConversationUsecase>((ref) {
  final repository = ref.read(messagingRepositoryProvider);
  return GetConversationUsecase(repository: repository);
});

final getConversationsListUsecaseProvider =
    Provider<GetConversationsListUsecase>((ref) {
      final repository = ref.read(messagingRepositoryProvider);
      return GetConversationsListUsecase(repository: repository);
    });

final getUnreadCountUsecaseProvider = Provider<GetUnreadCountUsecase>((ref) {
  final repository = ref.read(messagingRepositoryProvider);
  return GetUnreadCountUsecase(repository: repository);
});

final getNotificationsUsecaseProvider = Provider<GetNotificationsUsecase>((ref) {
  final repository = ref.read(messagingRepositoryProvider);
  return GetNotificationsUsecase(repository: repository);
});

class CheckUserExistsUsecase {
  final IMessagingRepository repository;

  CheckUserExistsUsecase({required this.repository});

  Future<Either<Failure, bool>> call(String email) {
    return repository.checkUserExists(email);
  }
}

class GetOrCreateConversationUsecase {
  final IMessagingRepository repository;

  GetOrCreateConversationUsecase({required this.repository});

  Future<Either<Failure, ConversationEntity>> call(String receiverEmail) {
    return repository.getOrCreateConversation(receiverEmail);
  }
}

class SendMessageUsecase {
  final IMessagingRepository repository;

  SendMessageUsecase({required this.repository});

  Future<Either<Failure, MessageEntity>> call({
    required String receiverId,
    required String conversationId,
    required String message,
  }) {
    return repository.sendMessage(
      receiverId: receiverId,
      conversationId: conversationId,
      message: message,
    );
  }
}

class GetConversationUsecase {
  final IMessagingRepository repository;

  GetConversationUsecase({required this.repository});

  Future<Either<Failure, List<MessageEntity>>> call(String conversationId) {
    return repository.getConversation(conversationId);
  }
}

class GetConversationsListUsecase {
  final IMessagingRepository repository;

  GetConversationsListUsecase({required this.repository});

  Future<Either<Failure, List<ConversationEntity>>> call() {
    return repository.getConversationsList();
  }
}

class GetUnreadCountUsecase {
  final IMessagingRepository repository;

  GetUnreadCountUsecase({required this.repository});

  Future<Either<Failure, int>> call() {
    return repository.getUnreadCount();
  }
}

class GetNotificationsUsecase {
  final IMessagingRepository repository;

  GetNotificationsUsecase({required this.repository});

  Future<Either<Failure, List<MessageNotificationEntity>>> call() {
    return repository.getNotifications();
  }
}

