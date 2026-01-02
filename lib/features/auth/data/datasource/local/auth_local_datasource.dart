import 'package:businesstrack/core/services/hive/Hive_Service.dart';
import 'package:businesstrack/features/auth/data/datasource/remote/auth_datasource.dart';
import 'package:businesstrack/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



// Create provider
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return AuthLocalDatasource(
    hiveService: hiveService,
  );
});
class AuthLocalDatasource implements IAuthDataSource{
  final HiveService _hiveService;

   AuthLocalDatasource({
    required HiveService hiveService,
  }) : _hiveService = hiveService;



  @override
  Future<AuthHiveModel?> login(String email, String password) async{
    try{
    final user = await  _hiveService.loginUser(email,password);
    return user;
   }catch(e){
    return null;
   }
  }


  @override
  Future<bool> updateUser(AuthHiveModel user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
  @override
  Future<bool> deleteUser(String authId) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> getUserByEmail(String email) {
    // TODO: implement getUserByEmail
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> getUserById(String authId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<bool> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }
  
  @override
  Future<bool> logout() async {
    try {
      // Assuming authId is available in some way, e.g., from a session manager
      final String authId = 'currentAuthId'; // Replace with actual authId retrieval
     await _hiveService.logoutUser(authId);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
  
  @override
  Future<bool> register(AuthHiveModel model) async {
    try{
       await _hiveService.registerUser( model);
      return Future.value(true);
    }catch(e){
      return Future.value(false);
    } 
  }
  
  @override
  Future<bool> isEmailExists(String email) {
    try{
      final exists= _hiveService. isEmailExists(email);
      return Future.value(exists);
    }catch(e){
      return Future.value(false);
    }
  }



}