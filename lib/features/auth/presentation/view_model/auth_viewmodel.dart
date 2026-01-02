import 'package:businesstrack/features/auth/domain/usecases/login_usecase.dart';
import 'package:businesstrack/features/auth/domain/usecases/register_usecase.dart';
import 'package:businesstrack/features/auth/presentation/state/auth.state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



//provider 
final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);


class AuthViewModel extends Notifier<AuthState>{
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  
  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUseCaseProvider);
    _loginUsecase = ref.read(LoginUsecaseProvider);
    return AuthState();
  }


//Register
  Future<void> register({
    required String fullName,
    required String email,
    String? phoneNumber,
    String? batchId,
    required String username,
    required String password,
  }) async {
    state= state.copywith(status: AuthStatus.loading);
    //wait for 2 seconds 
    await Future.delayed(Duration(seconds: 2));
    final params = RegisterUsecaseParams(
    fullName: fullName, 
    email: email, 
    phoneNumber: phoneNumber,
    password: password,
    );
    final result= await _registerUsecase(params);
    result.fold(
      (failure){
        state= state.copywith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (isRegistered){
        state= state.copywith(status: AuthStatus.registered);
        },
    );
  }

  //Login 
  Future<void> login({
    required String email,
    required String password,
  }) async{
    state = state.copywith( status: AuthStatus.loading);
    final params = LoginUsecaseParams(email: email, password: password);
    await Future.delayed(Duration(seconds: 2));

    final result = await _loginUsecase(params);

    result.fold(
      (failure){
        state= state.copywith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (authEntity){
        state= state.copywith(
          status: AuthStatus.authenticated,
          authEntity: authEntity,
        );
      },
    );
  }
}