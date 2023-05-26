import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/service/authenticationService.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends BaseModel {
  AuthenticationService _auth = sl<AuthenticationService>();
}
