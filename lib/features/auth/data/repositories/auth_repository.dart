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
  }) : _authLocalDatasource = authLocalDatasource,
       _authRemoteDatasource = authRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> register(AuthEntity user) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(user);
        await _authRemoteDatasource.register(apiModel);
        // Mirror to local Hive for offline login.
        final authModel = AuthHiveModel.fromEntity(user);
        await _authLocalDatasource.register(authModel);
        return const Right(true);
      } on DioException catch (e) {
        // If server is unreachable/timeout, fall back to offline Hive registration.
        final isTimeout = e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.connectionError;
        if (isTimeout) {
          try {
            if (user.email != null &&
                await _authLocalDatasource.isEmailExists(user.email!)) {
              return const Left(
                LocalDatabaseFailure(messgae: "Email already registered"),
              );
            }
            final authModel = AuthHiveModel.fromEntity(user);
            final result = await _authLocalDatasource.register(authModel);
            return result
                ? const Right(true)
                : Left(
                    LocalDatabaseFailure(
                      messgae: "Failed to register user offline",
                    ),
                  );
          } catch (err) {
            return Left(LocalDatabaseFailure(messgae: err.toString()));
          }
        }
        return Left(
          Apifailure(
            statusCode: e.response?.statusCode,
            message:
                (e.response?.data is Map && e.response?.data['message'] != null)
                    ? e.response?.data['message']
                    : "Registration failed",
          ),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      try {
        if (user.email != null &&
            await _authLocalDatasource.isEmailExists(user.email!)) {
          return const Left(
            LocalDatabaseFailure(messgae: "Email already registered"),
          );
        }

        final authModel = AuthHiveModel.fromEntity(user);
        final result = await _authLocalDatasource.register(authModel);

        return result
            ? const Right(true)
            : Left(LocalDatabaseFailure(messgae: "Failed to register user"));
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
  Future<Either<Failure, AuthEntity>> whoAmI() async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDatasource.whoAmI();
        if (apiModel != null) {
          return Right(apiModel.toEntity());
        }
        return const Left(Apifailure(message: 'Failed to fetch user'));
      } on DioException catch (e) {
        return Left(
          Apifailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? 'Failed to fetch user',
          ),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    }

    return const Left(Apifailure(message: 'No internet connection'));
  }

  @override
  Future<Either<Failure, AuthEntity>> updateProfile(AuthEntity entity) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(entity);
        final result = await _authRemoteDatasource.updateUser(apiModel);
        if (!result) {
          return const Left(Apifailure(message: 'Failed to update profile'));
        }
        final refreshed = await _authRemoteDatasource.whoAmI();
        if (refreshed != null) {
          return Right(refreshed.toEntity());
        }
        return Right(entity);
      } on DioException catch (e) {
        return Left(
          Apifailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? 'Failed to update profile',
          ),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    }

    return const Left(Apifailure(message: 'No internet connection'));
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(String filePath) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _authRemoteDatasource.uploadPhoto(filePath);
        if (result == null || result.trim().isEmpty) {
          return const Left(Apifailure(message: 'Upload failed'));
        }
        return Right(result);
      } on DioException catch (e) {
        return Left(
          Apifailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? 'Upload failed',
          ),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    }

    return const Left(Apifailure(message: 'No internet connection'));
  }

  @override
  Future<Either<Failure, bool>> forgotPassword(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _authRemoteDatasource.forgotPassword(email);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          Apifailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? 'Failed to request reset',
          ),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    }

    return const Left(Apifailure(message: 'No internet connection'));
  }

  @override
  Future<Either<Failure, bool>> resetPassword(
    String token,
    String newPassword,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _authRemoteDatasource.resetPassword(
          token,
          newPassword,
        );
        return Right(result);
      } on DioException catch (e) {
        return Left(
          Apifailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? 'Failed to reset password',
          ),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    }

    return const Left(Apifailure(message: 'No internet connection'));
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authLocalDatasource.logout();
      return result
          ? const Right(true)
          : const Left(LocalDatabaseFailure(messgae: "Failed to logout"));
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> Login(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDatasource.login(email, password);

        if (apiModel != null) {
          // Cache locally for offline login using entered credentials.
          final cachedUser = AuthHiveModel(
            authId: apiModel.id,
            fullName: apiModel.fullName,
            email: apiModel.email,
            phoneNumber: apiModel.phoneNumber,
            password: password,
            confirmPassword: password,
            profilePicture: apiModel.profilePicture,
          );
          await _authLocalDatasource.register(cachedUser);
          return Right(apiModel.toEntity());
        }

        return const Left(Apifailure(message: "Invalid credentials"));
      } on DioException catch (e) {
        final isTimeout = e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.connectionError;
        if (isTimeout) {
          try {
            final model = await _authLocalDatasource.login(email, password);

            if (model != null) {
              return Right(model.toEntity());
            }

            return const Left(
              LocalDatabaseFailure(messgae: "Invalid email or password"),
            );
          } catch (err) {
            return Left(LocalDatabaseFailure(messgae: err.toString()));
          }
        }
        return Left(
          Apifailure(
            statusCode: e.response?.statusCode,
            message:
                (e.response?.data is Map && e.response?.data['message'] != null)
                    ? e.response?.data['message']
                    : "Login failed",
          ),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _authLocalDatasource.login(email, password);

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

  @override
  Future<Either<Failure, AuthEntity>> adminLogin(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDatasource.adminLogin(
          email,
          password,
        );

        if (apiModel != null) {
          return Right(apiModel.toEntity());
        }

        return const Left(Apifailure(message: "Invalid credentials"));
      } on DioException catch (e) {
        return Left(
          Apifailure(
            statusCode: e.response?.statusCode,
            message:
                (e.response?.data is Map && e.response?.data['message'] != null)
                    ? e.response?.data['message']
                    : "Admin login failed",
          ),
        );
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      return const Left(Apifailure(message: 'No internet connection'));
    }
  }
}
