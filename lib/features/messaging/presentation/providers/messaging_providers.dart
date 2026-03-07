import 'package:businesstrack/features/messaging/domain/entities/message_entity.dart';
import 'package:businesstrack/features/messaging/domain/usecases/messaging_usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final conversationsListProvider = FutureProvider<List<ConversationEntity>>((
  ref,
) async {
  final usecase = ref.watch(getConversationsListUsecaseProvider);
  final result = await usecase.call();
  return result.fold((failure) => throw Exception(failure.message), (data) => data);
});

final unreadCountProvider = FutureProvider<int>((ref) async {
  final usecase = ref.watch(getUnreadCountUsecaseProvider);
  final result = await usecase.call();
  return result.fold((failure) => throw Exception(failure.message), (data) => data);
});

final messagesProvider = FutureProvider.family<List<MessageEntity>, String>((
  ref,
  conversationId,
) async {
  final usecase = ref.watch(getConversationUsecaseProvider);
  final result = await usecase.call(conversationId);
  return result.fold((failure) => throw Exception(failure.message), (data) => data);
});

final notificationsProvider = FutureProvider<List<MessageNotificationEntity>>((
  ref,
) async {
  final usecase = ref.watch(getNotificationsUsecaseProvider);
  final result = await usecase.call();
  return result.fold((failure) => throw Exception(failure.message), (data) => data);
});

