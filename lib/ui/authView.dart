import 'package:flutter/material.dart';
import 'package:material_snackbar/material_snackbar.dart';
import 'package:material_snackbar/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/viewModels/authViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/homeView.dart';
import 'package:vendoorr/ui/login.dart';

class AuthView extends StatelessWidget {
  Api _api = sl<Api>();
  @override
  Widget build(BuildContext context) {
    return Consumer<RootProvider>(builder: (context, rootProv, _) {
      return BaseView<AuthViewModel>(
        onModelReady: (model) {
          rootProv.dispose();
        },
        builder: (context, model, child) {
          return Scaffold(
            body: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: LocalColors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            child: Center(
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/logo_sign_100x.png",
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Image.asset(
                                      "assets/images/logo_text_200x.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  // child: AspectRatio(
                                  // aspectRatio: 1,
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    constraints: BoxConstraints(
                                        maxWidth: 800, minWidth: 0),
                                    child: Image.asset(
                                      "assets/images/login.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  // ),
                                ),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 700),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    "Vendoor Technologies ©2021",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: LocalColors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    color: LocalColors.offWhite,
                    child: Center(
                      child: Navigator(
                        initialRoute: '/login',
                        onGenerateRoute: (settings) {
                          switch (settings.name) {
                            case '/login':
                              return MaterialPageRoute(
                                  builder: (context) => Login());
                              break;
                            default:
                              return MaterialPageRoute(
                                  builder: (context) => HomeView());
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
