import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:businesstrack/features/auth/data/datasource/remote/auth_datasource.dart';
import 'package:businesstrack/features/auth/data/models/auth_hive_model.dart';
import 'package:businesstrack/features/auth/domain/entities/auth_entity.dart';
import 'package:businesstrack/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final AuthRepositoryProvider = Provider<IAuthRespository>((ref){
  return AuthRepository(authDataSource: ref.read(authLocalDatasourceProvider));
});
class AuthRepository implements IAuthRespository {
  final IAuthDataSource _authDataSource;
  AuthRepository({required IAuthDataSource authDataSource})
    : _authDataSource = authDataSource;
  @override
  Future<Either<Failure, AuthEntity>> Login(String email, String password) async{
 try{
      final result = await _authDataSource.login(email, password);
      if(result != null){
        final entity = result.toEntity();
        return Right(entity);
      }else{
        return Left(LocalDatabaseFailure(messgae: "Invalid email or password"));
      }
    }catch(e){
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async{
    try{
      final result = await _authDataSource.getCurrentUser();
      if(result != null){
        final entity = result.toEntity();
        return Right(entity);
      }else{
        return Left(LocalDatabaseFailure(messgae: "No user logged in"));
      }
    }catch(e){
      return Left(LocalDatabaseFailure(messgae: e.toString()));
    }
   
  }

  @override
Future<Either<Failure, bool>> logout() async {
  try {
    final result = await _authDataSource.logout();

    if (result) {
      return const Right(true);
    } else {
      return Left(LocalDatabaseFailure(messgae: "Logout failed"));
    }
  } catch (e) {
    return Left(LocalDatabaseFailure(messgae: e.toString()));
  }
}


  @override
  Future<Either<Failure, bool>> register(AuthEntity entity)  async{
  try{
    //model ma convert gara
    final model = AuthHiveModel.fromEntity(entity);
    final result = await _authDataSource.register(model);
    if(result){
      return Right(true);
    }else{
      return  Left(
        LocalDatabaseFailure(messgae: 'Failed to register user'),
      );
    }

  }catch(e){
    return Left(LocalDatabaseFailure(messgae: e.toString()));
  }
  }
}
