import 'package:equatable/equatable.dart';


class UserEntity extends Equatable {
  final String? userId;
  final String username;
  final String? status;
  final String? fullname;
  final String? email;
  final String? phoneNumber;
  final String? profileImage;

  const UserEntity({
    this.userId,
    required this.username,
    this.status,
    this.fullname,
    this.email,
    this.phoneNumber,
    this.profileImage,
  });

  @override
  List<Object?> get props => [userId, username, status, fullname, email, phoneNumber, profileImage];
}
