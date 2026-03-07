import 'package:businesstrack/features/users/data/datasources/local/user_local_datasource.dart';
import 'package:businesstrack/features/users/data/datasources/remote/user_remote_datasource.dart';
import 'package:businesstrack/features/users/data/datasources/user_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRemoteDataSourceProvider = Provider<IUserRemoteDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return UserRemoteDataSourceImpl(dio: dio);
});

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(baseUrl: 'http://10.0.2.2:5000'));
});
