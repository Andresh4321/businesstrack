import 'dart:io';

import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/core/services/connectivity/network_info.dart';
import 'package:businesstrack/features/users/data/datasources/local/user_local_datasource.dart';
import 'package:businesstrack/features/users/data/datasources/remote/user_remote_datasource.dart';
import 'package:businesstrack/features/users/data/datasources/user_datasource.dart';
import 'package:businesstrack/features/users/data/models/user_hive_model.dart';
import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:businesstrack/features/users/domain/repositories/user_repository.dart';
import 'package:businesstrack/features/users/presentation/state/user_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//internet on

final UserRepositoryProvider = Provider<IUserRespository>((ref) {
  return UserRepository(
    datasource: ref.read(userLocalDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
    remoteDatasource: ref.read(IUserRemoteDatasourceProvider),
  );
});

class UserRepository implements IUserRespository {
  final IUserDatasource _datasource;
  final NetworkInfo _networkInfo;
  final IUserRemoteDatasource _remoteDatasource;

  UserRepository({
    required IUserDatasource datasource,
    required NetworkInfo networkInfo,
    required IUserRemoteDatasource remoteDatasource,
  }) : _datasource = datasource,
       _networkInfo = networkInfo,
       _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, bool>> createuser(UserEntity user) async {
    try {
      final model = UserHiveModel.fromEntity(user);

      final result = await _datasource.createuser(model);

      if (result) {
        return const Right(true);
      }

      return const Left(LocalDatabaseFailure(messgae: 'Failed to create user'));
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteuser(String userId) async {
    try {
      final result = await _datasource.deleteuser(userId);

      if (result) {
        return const Right(true);
      } else {
        return const Left(
          LocalDatabaseFailure(messgae: 'Failed to delete user'),
        );
      }
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllusers() async {
    try {
      final model = await _datasource.getAllusers();

      final entitites = UserHiveModel.toEntityList(model);
      return Right(entitites);
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getuserById(String userId) async {
    try {
      final model = await _datasource.getuserById(userId);
      if (model != null) {
        return Right(model.toEntity());
      }
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateuser(UserEntity user) async {
    try {
      final model = UserHiveModel.fromEntity(user);

      final result = await _datasource.updateuser(model);

      if (result) {
        return const Right(true);
      }

      return const Left(LocalDatabaseFailure(messgae: 'Failed to update user'));
    } catch (e) {
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(File image) async {
    if (await _networkInfo.isConnected) {
      try {
        final fileName = await _remoteDatasource.uploadImage(image);
        return Right(fileName);
      } catch (e) {
        return Left(Apifailure(message: e.toString()));
      }
    } else {
      return Left(Apifailure(message: "No internet conection"));
    }
  }
}
