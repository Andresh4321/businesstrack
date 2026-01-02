

import 'package:businesstrack/features/users/data/models/user_hive_model.dart';

abstract interface class IUserDatasource {
 Future< List<UserHiveModel>> getAllusers();
  Future< UserHiveModel> getuserById(String batchId);
  Future< bool> createuser(UserHiveModel entity);
  Future< bool> updateuser(UserHiveModel entity);
  Future< bool> deleteuser(String userId);

}
