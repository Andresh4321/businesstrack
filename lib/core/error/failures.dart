

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

