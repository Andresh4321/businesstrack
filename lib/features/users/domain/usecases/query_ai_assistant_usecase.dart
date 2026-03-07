import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/usecases/app_usecase.dart';
import 'package:businesstrack/features/users/data/repositories/repository_providers.dart';
import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:businesstrack/features/users/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QueryAIAssistantParams extends Equatable {
  final String userId;
  final String query;

  const QueryAIAssistantParams({required this.userId, required this.query});

  @override
  List<Object?> get props => [userId, query];
}

final queryAIAssistantUsecaseProvider = Provider<QueryAIAssistantUsecase>((
  ref,
) {
  final repository = ref.read(userRepositoryProvider);
  return QueryAIAssistantUsecase(repository: repository);
});

class QueryAIAssistantUsecase
    implements UsecasewithParams<AIAssistantEntity, QueryAIAssistantParams> {
  final IUserRepository _repository;

  QueryAIAssistantUsecase({required IUserRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, AIAssistantEntity>> call(
    QueryAIAssistantParams params,
  ) {
    return _repository.queryAIAssistant(params.userId, params.query);
  }
}
