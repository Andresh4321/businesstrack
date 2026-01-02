import 'package:equatable/equatable.dart';


class UserEntity extends Equatable {
  final String? userId;
  final String username;
  final String? status;

  const UserEntity({this.userId, required this.username, this.status});

  @override
  List<Object?> get props => [userId, username, status];
}
