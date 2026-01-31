import 'package:businesstrack/features/users/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

enum userStatus { initial, loading, loaded, error, created, updated, delete }

class userState extends Equatable {
  final userStatus status;
  final List<UserEntity> users;
  final String? errorMessage;

  //store image name temporarily
  final String? uploadPhotoName;

  const userState({
    this.status = userStatus.initial,
    this.users = const [],
    this.errorMessage,
    this. uploadPhotoName,
  });

  // Copywith function
  userState copyWith({
    userStatus? status,
    List<UserEntity>? users,
    String? errorMessage,
    String? uploadPhotoName,
  }) {
    return userState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadPhotoName: uploadPhotoName ?? this.uploadPhotoName,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, users, errorMessage];

  static userStatus? get loading => null;
}
