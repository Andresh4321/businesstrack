import 'dart:io';

import 'package:businesstrack/core/error/failures.dart';
import 'package:businesstrack/features/users/domain/usecases/create_user_usecase.dart';
import 'package:businesstrack/features/users/domain/usecases/get_all_user_usecase.dart';
import 'package:businesstrack/features/users/domain/usecases/update_user_usecase.dart';
import 'package:businesstrack/features/users/domain/usecases/upload_photo_usecase.dart';
import 'package:businesstrack/features/users/presentation/state/user_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userViewmodelProvider = NotifierProvider<UserViewmodel, userState>(() {
  return UserViewmodel();
});

class UserViewmodel extends Notifier<userState> {
  late final GetAllUserUsecase _GetAllUserUsecase;
  late final UpdateuserUsecase _UpdateuserUsecase;
  late final CreateuserUsecase _CreateuserUsecase;
  late final UploadPhotoUsecase _uploadPhotoUsecase;

  @override
  userState build() {
    _GetAllUserUsecase = ref.read(getAlluserUsecaseProvider);
    _UpdateuserUsecase = ref.read(updateuserUsecaseProvider);
    _CreateuserUsecase = ref.read(createuserUsecaseProvider);
    _uploadPhotoUsecase = ref.read(UploadPhotoUsecaseProvider);
    return userState();
  }

  Future<void> getAllusers() async {
    state = state.copyWith(status: userStatus.loading);
    final result = await _GetAllUserUsecase();

    result.fold(
      (left) {
        state = state.copyWith(errorMessage: left.message);
      },
      (users) {
        state = state.copyWith(status: userStatus.loaded, users: users);
      },
    );
  }

  Future<void> createuser(String userName) async {
    state = state.copyWith(status: userState.loading);

    final result = await _CreateuserUsecase(
      CreateuserUsecaseParams(userName: userName),
    );
    result.fold(
      (left) {
        state = state.copyWith(
          status: userStatus.error,
          errorMessage: left.message,
        );
      },
      (right) {
        state = state.copyWith(status: userStatus.loaded);
      },
    );
  }

  Future<void> uploadPhoto(File photo) async {
    state = state.copyWith(status: userState.loading);

    final result = await _uploadPhotoUsecase(photo);

    result.fold(
      (Failure) {
        state = state.copyWith(
          status: userStatus.error,
          errorMessage: Failure.message,
        );
      },
      (imageName) {
        state = state.copyWith(
          status: userStatus.loaded,
          uploadPhotoName: imageName,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearUploadPhotoName() {
    state = state.copyWith(uploadPhotoName: null);
  }
}
