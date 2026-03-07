import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/users/data/repositories/repository_providers.dart';
import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:businesstrack/features/users/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetUserNotificationsParams extends Equatable {
  final String userId;

  const GetUserNotificationsParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final getUserNotificationsUsecaseProvider =
    Provider<GetUserNotificationsUsecase>((ref) {
      final repository = ref.read(userRepositoryProvider);
      return GetUserNotificationsUsecase(repository: repository);
    });

class GetUserNotificationsUsecase
    implements
        UsecasewithParams<
          List<NotificationEntity>,
          GetUserNotificationsParams
        > {
  final IUserRepository _repository;

  GetUserNotificationsUsecase({required IUserRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
    GetUserNotificationsParams params,
  ) {
    return _repository.getNotifications(params.userId);
  }
}
