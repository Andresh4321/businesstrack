import 'package:businesstrack/features/users/data/datasources/datasource_providers.dart';
import 'package:businesstrack/features/users/data/datasources/local/user_local_datasource.dart';
import 'package:businesstrack/features/users/data/datasources/user_datasource.dart';
import 'package:businesstrack/features/users/data/repositories/user_repository_impl.dart';
import 'package:businesstrack/features/users/domain/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  final remoteDataSource = ref.read(userRemoteDataSourceProvider);
  final localDataSource = ref.read(userLocalDataSourceProvider);
  return UserRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});
