import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/service/sharedPreferences.dart';

SharedPreferencesService sharedPref = sl<SharedPreferencesService>();
Future<Map<String, String>> tokenConfig() async {
  String tokenSF = await sharedPref.getStringValuesSF("token");

  Map<String, String> token = {
    "Content-Type": "application/json",
    "Authorization": "Token $tokenSF",
  };
  return token;
}

removeToken() async {
  bool logout = await sharedPref.removeFromSF(key: "token");
}
