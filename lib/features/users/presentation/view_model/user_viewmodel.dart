import 'package:businesstrack/features/users/domain/usecases/create_user_usecase.dart';
import 'package:businesstrack/features/users/domain/usecases/get_all_user_usecase.dart';
import 'package:businesstrack/features/users/domain/usecases/update_user_usecase.dart';
import 'package:businesstrack/features/users/presentation/state/user_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final userViewmodelProvider = NotifierProvider<UserViewmodel,userState>((){
  return UserViewmodel();
});

class UserViewmodel extends Notifier<userState>{

  late final GetAllUserUsecase _GetAllUserUsecase;
  late final UpdateuserUsecase _UpdateuserUsecase;
  late final CreateuserUsecase _CreateuserUsecase;

  @override
userState build() {
    _GetAllUserUsecase = ref.read(getAlluserUsecaseProvider);
    _UpdateuserUsecase = ref.read(updateuserUsecaseProvider);
    _CreateuserUsecase = ref.read(createuserUsecaseProvider);
    return userState();
  }

  Future <void> getAllusers() async{
    state = state.copyWith(status:userStatus.loading);
    final result = await  _GetAllUserUsecase();

    result.fold(
      (left){
        state = state.copyWith(
          errorMessage: left.message,
        );
      },
      (users){
        state = state.copyWith(status:userStatus.loaded,users:users);
      },
    );
  }

  Future <void> createuser(String userName) async{
    state = state.copyWith(status:userState.loading);

    final result = await _CreateuserUsecase(
      CreateuserUsecaseParams(userName: userName),
    );
    result.fold((left){
      state = state.copyWith(status:userStatus.error, errorMessage: left.message);
    }, (right){
      state = state.copyWith(
        status:userStatus.loaded
      );
    }
    );
  
  }
}
