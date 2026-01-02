import 'package:businesstrack/core/constants/hive_table_constant.dart';
import 'package:businesstrack/features/auth/data/models/auth_hive_model.dart';
import 'package:businesstrack/features/users/data/models/user_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  //Get user box
  Box<UserHiveModel> get _userBox =>
      Hive.box<UserHiveModel>(HiveTableConstant.userTable);

  //Initialize Hive
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapters();
    await _openBoxes();
    await insertDummyuseres();
  }

  Future<void> insertDummyuseres() async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userTable);
    final dummyuseres = [
      UserHiveModel(username: '35-A'),
      UserHiveModel(username: '35-B'),
      UserHiveModel(username: '35-C'),
      UserHiveModel(username: '35-D'),
    ];
    for (var user in dummyuseres) {
      await box.put(user.userId, user);
    }
    await box.close();
  }

  //Register all type adapters
  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }

    //Register other adapter here
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }

  //Open all boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<UserHiveModel>(HiveTableConstant.userTable);
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
  }

  //Create a new user
  Future<UserHiveModel> createuser(UserHiveModel user) async {
    await _userBox.put(user.userId, user);
    return user;
  }

  //Get all useres
  List<UserHiveModel> getAlluseres() {
    return _userBox.values.toList();
  }

  //Get user by ID
  Future<UserHiveModel> getuserById(String userId) {
    final user = _userBox.get(userId);
    if (user == null) {
      throw Exception('user with ID $userId not found');
    }
    return Future.value(user);
  }

  //Update a user
  Future<void> updateuser(UserHiveModel user) async {
    await _userBox.put(user.userId, user);
  }

  //Delete a user
  Future<void> deleteuser(String userId) async {
    await _userBox.delete(userId);
  }

  //Delete all useres
  Future<void> deleteAlluseres() async {
    await _userBox.clear();
  }

  //Close all boxes
  Future<void> close() async {
    await Hive.close();
  }

  //-----------------Auth Queries
  Box<AuthHiveModel> get _authBox =>
  Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  Future<AuthHiveModel> registerUser(AuthHiveModel model) async{
    await _authBox.put(model.authId, model);
    return model;
  }

  //Login
  Future<AuthHiveModel?> loginUser(String email,String password) async{
    final users = _authBox.values.where((user) => user.email == email && user.password == password);
    if(users.isNotEmpty){
      return users.first;
    }
    return null;
  }
  //logout 
  Future<void> logoutUser(String authId) async{
    await _authBox.delete(authId);
  }

  //get current user
  AuthHiveModel? getCurrentUser(String authId){
    return _authBox.get(authId);
  }

  bool isEmailExists(String email) {
    final users = _authBox.values.where((user) => user.email == email);
    return users.isNotEmpty;
  }
}
