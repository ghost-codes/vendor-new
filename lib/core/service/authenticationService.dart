import 'dart:async';
import 'dart:convert';

import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/service/sharedPreferences.dart';
import 'package:vendoorr/core/util/tokenConfig.dart';
import 'package:vendoorr/core/viewModels/loginViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';

class AuthenticationService {
  Api _api = sl<Api>();
  RootProvider rootProvider = sl<RootProvider>();
  SharedPreferencesService sharedPref = sl<SharedPreferencesService>();

  StreamController<UserModel> userController = StreamController.broadcast();
  StreamController<bool> isLoggedIn = StreamController.broadcast();

  Future<Map<String, dynamic>> login(Map<String, String> userCred) async {
    String error = "";
    UserModel user =
        await _api.loginApi(userCred).onError((String err, stackTrace) {
      error = err;

      return null;
    });
    bool hasUser = user != null;
    if (hasUser) {
      userController.add(user);
      rootProvider.userModel = user;
    }
    return {"isLoggedIn": hasUser, "err": error};
  }

  // Future tokenAuth() async {
  //   rootProvider.setIsTokenAuthentication(true);
  //   bool log = await _api.tokenAuth();
  //   if (log) {
  //     String userJson = await sharedPref.getStringValuesSF("userModel");
  //     UserModel userModel = UserModel.fromJson(json.decode(userJson));
  //     userController.add(userModel);
  //     rootProvider.userModel = userModel;
  //   }
  //   isLoggedIn.add(log);
  //   rootProvider.setIsTokenAuthentication(false);
  // }

  logout() {
    _api.logout();
  }

  logoutApp() async {
    await removeToken();
    userController.add(null);
    isLoggedIn.add(false);
  }

  AuthenticationService() {
    _api.authStream.listen((event) {
      if (event) {
        logoutApp();
      }
    });
  }
}
