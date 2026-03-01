import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

//local database failure
class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure({
    String messgae = 'local database operation daiked',
  }) : super(messgae);
}

//API Failure with status code
class Apifailure extends Failure {
  final int? statusCode;

  const Apifailure({required String message, this.statusCode}) : super(message);

  //   @override
  //  List<Object?> get props => [message,statusCode];
}

class ApiFailure extends Apifailure {
  const ApiFailure({required String message, int? statusCode})
    : super(message: message, statusCode: statusCode);
}

class Apifalure extends Apifailure {
  const Apifalure({required String message, int? statusCode})
    : super(message: message, statusCode: statusCode);
}

class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message);
}
