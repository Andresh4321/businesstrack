import 'package:businesstrack/core/error/failures.dart';
import 'package:dartz/dartz.dart';


abstract interface class UsecasewithParams<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

abstract interface class UsecasewithoutParams<SuccessType> {
  Future<Either<Failure, SuccessType>> call();
}
