import 'package:rxdart/rxdart.dart';

import '../../helper/logger/logger.dart';
import '../../model/login/login_response.dart';
import '../data_base/db_manager.dart';

class UserDataStore {
  final DBManager _dbManager;
  UserInformation? _user;

  BehaviorSubject<void> _permissionChanged = BehaviorSubject();

  Stream<void> get permissionChanged => _permissionChanged;

  UserDataStore(this._dbManager);

  Future<UserInformation?> getUser() async {
    // TODO: add user caching mechanism to no open DB everytime app needs user
    // This was commented because of the issue with user avatar update
    // if (_user != null) return Future.value(_user);

    final user = await _dbManager.queryAllRows<UserInformation>();

    if (user.isNotEmpty) {
      Map<String, dynamic> userMap = Map.from(user.first);

      _user = UserInformation.fromJson(userMap);
      return _user;
    } else {
      return null;
    }
  }

  Future<int> insert(UserInformation u) async {
    printLog("APPLOG", "Insert message");
    await _dbManager.delete<UserInformation>();
    final userJson = u.toJson();

    return _dbManager.insert<UserInformation>(userJson);
  }

  Future<int> update(UserInformation u) async {
    printLog("APPLOG", "Insert message");
    await _dbManager.delete<UserInformation>();
    final userJson = u.toJson();
    return _dbManager.update<UserInformation>(userJson);
  }

  Future<int> deleteUser() async {
    _user = null;

    return _dbManager.delete<UserInformation>();
  }


}