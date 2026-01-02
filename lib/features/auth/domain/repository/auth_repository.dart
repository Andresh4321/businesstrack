import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/auth/domain/entities/auth_entity.dart';
import 'package:dartz/dartz.dart';


abstract interface class IAuthRespository {
  Future<Either<Failure, bool>> register(AuthEntity entity);
  Future<Either<Failure, AuthEntity>> Login(String email, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  Future<Either<Failure, void>> logout();
}
