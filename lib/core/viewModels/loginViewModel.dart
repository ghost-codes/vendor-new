import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/service/authenticationService.dart';
import 'package:vendoorr/core/service/sharedPreferences.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

import 'package:http/http.dart' as http;
import 'package:vendoorr/ui/widgets/firstPrinterAssign.dart';

class LoginViewModel extends BaseModel {
  bool _passObscure = true;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  AuthenticationService _auth = sl<AuthenticationService>();
  SharedPreferencesService sharedPref = sl<SharedPreferencesService>();
  Map<String, String> userCred = {};
  String _errorMessage = '';
  bool isLoginClickable = false;

  bool get passObscure => _passObscure;
  String get errorMessage => _errorMessage;

  String _signUrl = "https://www.vendoorr.com/";
  String _forgotPassword = "https://www.vendoorr.com/";

  setPassVis() {
    _passObscure = !_passObscure;
    notifyListeners();
  }

  // tokenLog() async {
  //   setState(ViewState.Busy);
  //   await _auth.tokenAuth();
  //   setState(ViewState.Idle);
  // }

  onFieldChange() {
    isLoginClickable = loginFormKey.currentState.validate();
    notifyListeners();
  }

  Future<void> signUpRedirect() async {
    await canLaunch(_signUrl)
        ? await launch(_signUrl)
        : throw 'Could not launch $_signUrl';
  }

  void forgotPasswordRedirect() async {
    await canLaunch(_forgotPassword)
        ? await launch(_forgotPassword)
        : throw 'Could not launch $_forgotPassword';
  }

  Future<bool> isFirstTime() async {
    bool isFirstTime =
        json.decode(await sharedPref.getStringValuesSF('first_time') ?? "true");
    if (isFirstTime != null && !isFirstTime) {
      sharedPref.addStringToSF(key: 'first_time', value: "false");
      return false;
    } else {
      sharedPref.addStringToSF(key: 'first_time', value: "false");
      return true;
    }
  }

  void login(context) async {
    var form = loginFormKey.currentState;
    Map<String, dynamic> loginResponse = {};
    bool isSucessful;

    if (form.validate()) {
      form.save();
      setState(ViewState.Busy);

      loginResponse = await _auth.login(userCred);

      isSucessful = loginResponse["isLoggedIn"];

      if (!isSucessful & isSucessful != null) {
        _errorMessage = loginResponse["err"];
        notifyListeners();
      }
      if (isSucessful != null && isSucessful) {
        await isFirstTime().then((isFirstTime) async {
          if (isFirstTime) {
            await showDialog(
                barrierColor: LocalColors.primaryColor.withOpacity(0.2),
                context: context,
                builder: (context) {
                  return FirstPrinterAssign();
                });
          }
        });
        notifyListeners();
      }
      setState(ViewState.Idle);
    }
  }

  String usernameValidator(String val) {
    if (val.length == 0) {
      return "";
    } else {
      return null;
    }
  }

  String passValidator(String val) {
    if (val.length == 0) {
      return "";
    } else {
      return null;
    }
  }
}
