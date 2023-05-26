import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/viewModels/loginViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/core/service/printingService.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PrintingService printingService = sl<PrintingService>();
    return Consumer<RootProvider>(builder: (context, rootProv, child) {
      return BaseView<LoginViewModel>(
        onModelReady: (model) {
          // model.tokenLog();
        },
        builder: (context, model, child) {
          return Stack(
            children: [
              Center(
                child: Container(
                  width: 400,
                  padding: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                      color: LocalColors.white,
                      borderRadius:
                          BorderRadius.circular(ConstantValues.BorderRadius),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 9,
                          color: LocalColors.black.withOpacity(0.1),
                          offset: Offset(-5, 15),
                        )
                      ]),
                  child: Form(
                    key: model.loginFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        model.errorMessage.length == 0
                            ? SizedBox.shrink()
                            : Container(
                                padding:
                                    EdgeInsets.all(ConstantValues.PadSmall / 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: LocalColors.error.withOpacity(0.9),
                                ),
                                child: Text(
                                  model.errorMessage,
                                  style: TextStyle(
                                    color: LocalColors.white,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(
                                color: LocalColors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                fontFamily: 'Montserrat',
                                letterSpacing: 1.2,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                model.signUpRedirect();
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: LocalColors.primaryColor,
                                    fontFamily: "Montserrat"),
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: ConstantValues.PadWide,
                              ),
                              TextFormField(
                                // validator: model.usernameValidator,
                                onSaved: (val) {
                                  model.userCred["username"] = val;
                                },
                                onChanged: (value) {
                                  model.onFieldChange();
                                },
                                cursorColor: LocalColors.primaryColor,
                                decoration: InputDecoration(
                                  filled: true,
                                  focusColor: LocalColors.offWhite,
                                  fillColor: LocalColors.offWhite,
                                  hintText: "Username",
                                  hintStyle: TextStyle(
                                    color: LocalColors.grey,
                                    fontFamily: "Montserrat",
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person_outlined,
                                    size: 20,
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: LocalColors.primaryColor),
                                    borderRadius: BorderRadius.circular(
                                        ConstantValues.BorderRadius),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        ConstantValues.BorderRadius),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: ConstantValues.PadWide,
                              ),
                              TextFormField(
                                validator: model.passValidator,
                                onSaved: (val) {
                                  model.userCred["password"] = val;
                                },
                                onFieldSubmitted: (value) {
                                  model.login(context);
                                },
                                onChanged: (value) {
                                  model.onFieldChange();
                                },
                                obscureText: model.passObscure,
                                decoration: InputDecoration(
                                  filled: true,
                                  focusColor: LocalColors.offWhite,
                                  fillColor: LocalColors.offWhite,
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: LocalColors.grey,
                                    fontFamily: "Montserrat",
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),

                                  prefixIcon: Icon(
                                    Icons.lock_outline_rounded,
                                    size: 20,
                                  ),

                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      model.passObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    onPressed: model.setPassVis,
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: LocalColors.primaryColor),
                                    borderRadius: BorderRadius.circular(
                                        ConstantValues.BorderRadius),
                                  ),
                                  // enabledBorder:
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(
                                        ConstantValues.BorderRadius),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    model.forgotPasswordRedirect();
                                  },
                                  child: Text(
                                    "Forgotten Password",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontFamily: 'Montserrat',
                                      fontSize: 13,
                                      color: LocalColors.primaryColor,
                                      letterSpacing: 1.05,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 50),
                              TextButton(
                                  style: ButtonStyle(),
                                  onPressed: model.isLoginClickable
                                      ? () {
                                          model.login(context);
                                        }
                                      : null,

                                  // onPressed: () {
                                  //   printingService.printing();
                                  // },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    padding:
                                        EdgeInsets.all(ConstantValues.PadSmall),
                                    decoration: BoxDecoration(
                                      color: LocalColors.primaryColor,
                                      borderRadius: BorderRadius.circular(
                                          ConstantValues.BorderRadius),
                                    ),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        color: LocalColors.white,
                                        fontFamily: "Montserrat",
                                        fontSize: 18,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              model.state == ViewState.Idle
                  ? SizedBox.shrink()
                  : Container(
                      color: LocalColors.offWhite,
                      child: Loaders.fadingCube,
                    ),
            ],
          );
        },
      );
    });
  }
}
