import 'package:businesstrack/core/constants/app_constants.dart';
import 'package:businesstrack/features/users/data/datasources/user_remote_datasource.dart';
import 'package:businesstrack/features/users/data/repositories/user_repository_impl.dart';
import 'package:businesstrack/features/users/domain/repository/user_repository.dart';
import 'package:businesstrack/features/users/domain/usecases/user_usecases.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dio Provider (shared)
final userDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
    ),
  );
  return dio;
});

// Remote Data Sources
final userRemoteDataSourceProvider = Provider<IUserRemoteDataSource>((ref) {
  final dio = ref.watch(userDioProvider);
  return UserRemoteDataSource(dio: dio);
});

// Repositories
final userRepositoryProvider = Provider<IUserRepository>((ref) {
  final remoteDataSource = ref.watch(userRemoteDataSourceProvider);
  return UserRepository(remoteDataSource: remoteDataSource);
});

// Use Cases
final getUserProfileUsecaseProvider = Provider<GetUserProfileUsecase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUserProfileUsecase(repository: repository);
});

final updateUserProfileUsecaseProvider = Provider<UpdateUserProfileUsecase>((
  ref,
) {
  final repository = ref.watch(userRepositoryProvider);
  return UpdateUserProfileUsecase(repository: repository);
});

final queryAIAssistantUsecaseProvider = Provider<QueryAIAssistantUsecase>((
  ref,
) {
  final repository = ref.watch(userRepositoryProvider);
  return QueryAIAssistantUsecase(repository: repository);
});

final getAIAssistantHistoryUsecaseProvider =
    Provider<GetAIAssistantHistoryUsecase>((ref) {
      final repository = ref.watch(userRepositoryProvider);
      return GetAIAssistantHistoryUsecase(repository: repository);
    });

// State Providers
final userProfileProvider = FutureProvider((ref) async {
  final usecase = ref.watch(getUserProfileUsecaseProvider);
  final result = await usecase.call();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

final aiAssistantHistoryProvider = FutureProvider((ref) async {
  final usecase = ref.watch(getAIAssistantHistoryUsecaseProvider);
  final result = await usecase.call();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

final aiAssistantQueryProvider = FutureProvider.family<String, String>((
  ref,
  query,
) async {
  final usecase = ref.watch(queryAIAssistantUsecaseProvider);
  final result = await usecase.call(query);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});
