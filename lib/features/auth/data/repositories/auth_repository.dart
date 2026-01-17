import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/services/connectivity/network_info.dart';
import 'package:businesstrack/features/auth/data/datasource/auth_datasource.dart';
import 'package:businesstrack/features/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:businesstrack/features/auth/data/datasource/remote/authremotedatasource.dart';
import 'package:businesstrack/features/auth/data/models/auth_api_model.dart';
import 'package:businesstrack/features/auth/data/models/auth_hive_model.dart';
import 'package:businesstrack/features/auth/domain/entities/auth_entity.dart';
import 'package:businesstrack/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<IAuthRespository>((ref) {
  final authLocalDatasource = ref.read(authLocalDatasourceProvider);
  final authRemoteDatasource = ref.read(authRemoteProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return AuthRepository(
    authLocalDatasource: authLocalDatasource,
    authRemoteDatasource: authRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRespository {
  final IAuthDataSource _authLocalDatasource;
  final IAuthRemoteDataSource _authRemoteDatasource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthDataSource authLocalDatasource,
    required IAuthRemoteDataSource authRemoteDatasource,
    required NetworkInfo networkInfo,
  })  : _authLocalDatasource = authLocalDatasource,
        _authRemoteDatasource = authRemoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> register(AuthEntity user) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(user);
        await _authRemoteDatasource.register(apiModel);
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          Apifailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['messgae'] ?? "Registration failed",
          ),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      try {
        // final existingUser =
        //     await _authLocalDatasource.getUserByEmail(user.email);

        // if (existingUser != null) {
        //   return const Left(
        //     LocalDatabaseFailure(messgae: "Email already registered"),
        //   );
        // }

        final authModel = AuthHiveModel.fromEntity(user);
        final result = await _authLocalDatasource.register(authModel);

        return result
            ? const Right(true)
            : Left(
                LocalDatabaseFailure(messgae: "Failed to register user"),
              );
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }



  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final model = await _authLocalDatasource.getCurrentUser();
      if (model != null) {
        return Right(model.toEntity());
      }
      return const Left(LocalDatabaseFailure(messgae: "No user logged in"));
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authLocalDatasource.logout();
      return result
          ? const Right(true)
          : const Left(
              LocalDatabaseFailure(messgae: "Failed to logout"),
            );
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, AuthEntity>> Login(String email, String password) async {
     if (await _networkInfo.isConnected) {
      try {
        final apiModel =
            await _authRemoteDatasource.login(email, password);

        if (apiModel != null) {
          return Right(apiModel.toEntity());
        }

        return const Left(Apifailure(message: "Invalid credentials"));
      } on DioException catch (e) {
        return Left(
          Apifailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['messgae'] ?? "Login failed",
          ),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      try {
        final model =
            await _authLocalDatasource.login(email, password);

        if (model != null) {
          return Right(model.toEntity());
        }

        return const Left(
          LocalDatabaseFailure(messgae: "Invalid email or password"),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(messgae: e.toString()));
      }
    }
  }
}
