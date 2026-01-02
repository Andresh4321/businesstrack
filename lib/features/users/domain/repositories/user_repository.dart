import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';


abstract interface class IUserRespository {
  Future<Either<Failure, List<UserEntity>>> getAllusers();
  Future<Either<Failure, UserEntity>> getuserById(String userId);
  Future<Either<Failure, bool>> createuser(UserEntity entity);
    Future<Either<Failure, bool>> updateuser(UserEntity entity);
      Future<Either<Failure, bool>> deleteuser(String userId);
}
//return type: j pani huna sakyo
//patameter j [pani huna sakyo]

//int add(int a,int b)
//double add (double b)

//generic class

//t add(y)

//successtype add(params)

