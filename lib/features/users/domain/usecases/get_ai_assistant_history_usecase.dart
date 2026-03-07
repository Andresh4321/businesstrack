import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/users/data/repositories/repository_providers.dart';
import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:businesstrack/features/users/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetAIAssistantHistoryParams extends Equatable {
  final String userId;

  const GetAIAssistantHistoryParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final getAIAssistantHistoryUsecaseProvider =
    Provider<GetAIAssistantHistoryUsecase>((ref) {
      final repository = ref.read(userRepositoryProvider);
      return GetAIAssistantHistoryUsecase(repository: repository);
    });

class GetAIAssistantHistoryUsecase
    implements
        UsecasewithParams<
          List<AIAssistantEntity>,
          GetAIAssistantHistoryParams
        > {
  final IUserRepository _repository;

  GetAIAssistantHistoryUsecase({required IUserRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<AIAssistantEntity>>> call(
    GetAIAssistantHistoryParams params,
  ) {
    return _repository.getAIAssistantHistory(params.userId);
  }
}
